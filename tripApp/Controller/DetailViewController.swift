import Foundation
import UIKit

class detailViewController:UIViewController{

    var profile = Profile(userid: "error", username: "No name", backgroundImageUrl: "background", profileImageUrl: "person.crop.circle.fill")
    
    var myProfile :myProfile?{
        didSet{
            
        }
    }
    var discription:Discription? {
        didSet{
            fieldView.setupViews(messageid:discription!.id)
            getProfile()
            getComment()

        }
    }
    var discriptionImage = UIImage()
    let fieldView :textFieldView = {
        let view = textFieldView()
        return view
    }()
    var textFieldViewBottomConstraint: NSLayoutConstraint!
    let tableView = UITableView()
    var commentList = [Comment]()
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(fieldView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0.0,
                         left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0.0,
                         right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0.0)
        
       
        fieldView.anchor(top: tableView.bottomAnchor, paddingTop: 0.0,
                         left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0.0,
                         right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0.0,
                         height: 40)
        textFieldViewBottomConstraint = fieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0)
        textFieldViewBottomConstraint.isActive = true
        
        settingTableView()
        setNav()
    }
    
    func settingTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DetailViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(commentCell.self, forCellReuseIdentifier: "comment")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
                     self,
                     selector:#selector(keyboardWillShow(_:)),
                     name: UIResponder.keyboardWillShowNotification,
                     object: nil)
        NotificationCenter.default.addObserver(
                     self,
                     selector: #selector(keyboardWillHide(_:)),
                     name: UIResponder.keyboardWillHideNotification,
                     object: nil)
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
         
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        textFieldViewBottomConstraint.constant = -keyboardFrame.size.height + self.view.safeAreaInsets.bottom - 5
       
        print("オープン")
        print(textFieldViewBottomConstraint.constant)
        UIView.animate(withDuration: 1.0, animations: { [self] () -> Void in
            self.view.layoutIfNeeded()
        })
          
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textFieldViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 1.0, animations: { [self] () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func getProfile(){
        //自分の投稿かどうかを判別する
        if discription?.userid == FirebaseManager.shered.getMyUserid(){
            //自分の投稿
            myProfile = DataManager.shere.getMyProfile()
            let trashButton = UIImage(systemName: "trash.circle")
            let deleteItem = UIBarButtonItem(image:trashButton, style: .plain, target: self, action: #selector(delete(sender:)))
            deleteItem.tintColor = .darkGray
            navigationItem.rightBarButtonItem = deleteItem
            
        }
        else{
            FirebaseManager.shered.getProfile(userid: discription!.userid) { (result) in
                self.profile = result
            }
           
        }
    }
    func getComment(){
        
        FirebaseManager.shered.getComment(messageid: discription!.id) { data in
            self.commentList.removeAll()
            self.commentList = data
            self.tableView.reloadData()
            
        }
    }
    func setNav(){
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
        
        
    }
}


extension detailViewController:UITableViewDelegate,UITableViewDataSource,profileCellDelegate{
    @objc func back(sender : UIButton){
        self.navigationController?.popViewController(animated: true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    func toDetail(image: UIImage) {
        //遷移する
        let vc = ImageDetailViewContriller()
        vc.image = image
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }
    func toProfilePage() {
        let layout = UICollectionViewFlowLayout()
        
        let vc = profileViewController(collectionViewLayout: layout)
        vc.profile = profile
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let navigationController = rootVC?.children[1] as? UINavigationController
        rootVC?.selectedIndex = 1
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scroll",scrollView.panGestureRecognizer.translation(in: scrollView).y)
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)

       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + commentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setCell(disc: discription!, size: view.frame.width, image: discriptionImage)
            cell.delegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! commentCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setCell(comment: commentList[indexPath.row - 1 ],  size: view.frame.width)
            return cell
        }
      
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        fieldView.textfield.endEditing(true)
    }

    
   
    @objc func delete(sender : UIButton){
       deleteAlert()
    }
    func deleteAlert(){
        let alert = UIAlertController(title: "報告", message: "削除してもよろしいですか？", preferredStyle: .alert)
                let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { _ in
                    DataManager.shere.delete(id: self.discription!.id)
                    FirebaseManager.shered.deleteDiscription(postID: self.discription!.id)
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    StorageManager.shered.deleteDiscriptionImage(image: self.discription!.image)
                    
                })
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

                alert.addAction(selectAction)
                alert.addAction(cancelAction)

                present(alert, animated: true)
    }
}




