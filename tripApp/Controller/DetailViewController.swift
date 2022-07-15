import Foundation
import UIKit
import AVFoundation
class detailViewController:UIViewController{
    var profile = Profile(userid: "error", username: "No name", backgroundImageUrl: "background", profileImageUrl: "person.crop.circle.fill")
    
    var myProfile = MyProfile(userid: "", username: "", text: "",
                              backgroundImage: imageData(imageData: Data(), name: "background", url: "background"),
                              profileImage:  imageData(imageData: Data(), name: "person.crop.circle.fill", url: "person.crop.circle.fill"))
    
     
    var discription:Discription? {
        didSet{
            fieldView.setupViews(messageid:discription!.id)
            getProfile()
            getComment()

        }
    }
    var image = UIImage()
    var cell = DetailViewCell()
    
    let fieldView :textFieldView = {
        let view = textFieldView()
        return view
    }()
    var textFieldViewBottomConstraint: NSLayoutConstraint!
    let tableView = UITableView()
    var commentList = [Comment]()
    var player = AVPlayer()
    var subheight = CGFloat()
    var isMapVC = false
    var isProfile = false
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
            
            
            let trashButton = UIImage(systemName: "trash")
            let deleteItem = UIBarButtonItem(image:trashButton, style: .plain, target: self, action: #selector(delete(sender:)))
            deleteItem.tintColor = .darkGray
            navigationItem.rightBarButtonItem = deleteItem
        }
        else{
            FirebaseManager.shered.getProfile(userid: discription!.userid) { (result) in
                self.profile = result
            }
            let meunButton = UIImage(systemName: "ellipsis")
            let deleteItem = UIBarButtonItem(image:meunButton, style: .plain, target: self, action: #selector(report(sender:)))
            deleteItem.tintColor = .darkGray
            navigationItem.rightBarButtonItem = deleteItem
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
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 83
        let height = view.frame.height - statusBarHeight - navigationBarHeight - tabbarHeight - 40 - 20
        subheight = height
    }
}


extension detailViewController:UITableViewDelegate,UITableViewDataSource,profileCellDelegate{
    @objc func back(sender : UIButton){
//        if discription?.type == "video"{
//            cell.videoView.stop()
//        }
        
        if isMapVC {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: true)

    }
    func toDetail(image: UIImage) {
        //遷移する
        let vc = ImageDetailViewContriller()
        vc.image = image
        vc.modalPresentationStyle = .fullScreen
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    func toProfilePage() {
        let layout = UICollectionViewFlowLayout()
        
        let vc = profileViewController(collectionViewLayout: layout)
        vc.profile = profile
       
        if profile.userid != myProfile.userid {
            print("自分のじゃないよ")
            print(profile)
            vc.isMyProfile = false
        }
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let navigationController = rootVC?.children[1] as? UINavigationController
        rootVC?.selectedIndex = 1
        navigationController?.pushViewController(vc, animated: false)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + commentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            if discription!.type == "image"{
                cell.discImageView.image = image
            }
            else {
                cell.videoView.player = player
            }

            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setCell(disc: discription!, widthSize: view.frame.width, heightSize: subheight)
            
            cell.delegate = self
         
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! commentCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setCell(comment: commentList[indexPath.row - 1],  size: view.frame.width)
            return cell
        }
      
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        fieldView.textfield.endEditing(true)
    }
    @objc func report(sender : UIButton){
        alert()
    }
    
    func reportAlert(){
        let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
               
            // userid, post id と 報告内容
               let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
                   let report = "嫌がらせ・差別・誹謗中傷"
                   FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   print(report)
                   OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
               }
               let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                   let report = "内容が著しく事実と異なる"
                   FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
                   print(report)
               }
               let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
                  
                   let report = "性的表現"
                   FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   print(report)
                   OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
               }
            let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
                   
                    let report = "不適切な投稿"
                    FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                    print(report)
                    OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
                }
        
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                   print("キャンセル")
               }
               // OKのActionを追加する.
               myAlert.addAction(alertA)
               myAlert.addAction(alertC)
               myAlert.addAction(alertD)
               myAlert.addAction(alertE)
               myAlert.addAction(cancelAlert)
               

               // UIAlertを発動する.
               present(myAlert, animated: true, completion: nil)
    }
    func OKAlert(title:String,message:String){
        let myAlert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let oklAlert = UIAlertAction(title: "OK", style: .cancel)
        myAlert.addAction(oklAlert)
        present(myAlert, animated: true, completion: nil)
    }
    
    func alert(){
        let myAlert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertA = UIAlertAction(title: "報告する", style: .destructive) { [self] action in
            
            reportAlert()
        }
        let alertB = UIAlertAction(title: "ブロックする", style: .default) { [self] action in
            blockFriend()
        }
        let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
               print("キャンセル")
           }
        myAlert.addAction(alertA)
        myAlert.addAction(alertB)
        myAlert.addAction(cancelAlert)
        

        // UIAlertを発動する.
        present(myAlert, animated: true, completion: nil)
    }
    func blockFriend(){
        //ブロックする
        FollowManager.shere.block(userid: discription!.userid)
        //フォローを解除する
        FollowManager.shere.unfollow(userid: discription!.userid)
//        FirebaseManager.shered.unfollow(friendid: discription!.userid)
        //前の画面に戻る
        let nav = self.navigationController
        
        if isProfile {
            let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! profileViewController
            preVC.isReload = true
        }
        else {
            let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! MapViewController
            preVC.isReload = true
        }
        
        self.navigationController?.popViewController(animated: true)
        //ブロックした人の投稿は見れないようにする
        
        
    }
       
    @objc func delete(sender : UIButton){
       deleteAlert()
    }
    func deleteAlert(){
        let alert = UIAlertController(title: "報告", message: "削除してもよろしいですか？", preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { [self] _ in
                DataManager.shere.delete(id: self.discription!.id)
                FirebaseManager.shered.deleteDiscription(postID: self.discription!.id)
        
                if discription!.type == "image"{
                    StorageManager.shered.deleteDiscriptionImage(image: self.discription!.image)
                }else{
                    StorageManager.shered.deleteDiscriptionVideo(video: discription!.image)
                }
                
                //前の画面がmapなのかprofileなのかで処理がかわる
           
            if isMapVC {
                print("MapViewController")
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)! - 2] as! MapViewController
                preVC.isReload = true
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("profileViewController")
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)! - 2] as! profileViewController
                preVC.isReload = true
                self.navigationController?.popViewController(animated: true)
            }
                  
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
    }
}



