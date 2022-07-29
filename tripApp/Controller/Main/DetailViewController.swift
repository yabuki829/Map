import Foundation
import UIKit
import AVFoundation
import SwiftUI
class detailViewController:BaseViewController{
//    let customTransition = DetailtoVideoViewContorllerTransition()
    
    
    var profile = Profile(userid: "error", username: "No name", text: "",
                          backgroundImage: ProfileImage( url: "background", name: "background"),
                          profileImage:  ProfileImage( url: "person.crop.circle.fill", name: "person.crop.circle.fill"))
    
     
    var discription:Discription? {
        didSet{
            fieldView.setupViews(postid:discription!.id)
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
   
    var subheight = CGFloat()
    var isMapVC = false
    var isProfile = false

    
    override func viewDidLoad() {
        fieldView.delegate = self
        tableView.backgroundColor = .systemGray6

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
    

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var shouldAutorotate: Bool {
        print("回転禁止")
        return false
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
            profile = DataManager.shere.getMyProfile()
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


extension detailViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    @objc func back(sender : UIButton){
        cell.videoView.stop()
        if isMapVC {
            print("mapVC")
            self.navigationController?.popViewController(animated: true)
        }
        else{
           
            self.navigationController?.popViewController(animated: true)
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
            if discription!.type == "image"{
                cell.discImageView.image = image
                cell.dateLabel.text = self.discription!.created.covertString()
                cell.discTextLabel.text = self.discription!.text
            }
            else {
                if cell.videoView.player == nil {
                    cell.videoView.loadVideo(urlString: discription!.data.url) { result in
                        if result{
                            self.cell.videoView.setup()
                            self.cell.videoView.setupVideoTap()
                            self.cell.expandButton.isHidden = false
                            self.cell.dateLabel.text = self.discription!.created.covertString()
                            self.cell.discTextLabel.text = self.discription!.text
                            self.cell.videoView.backgroundColor = .black
                        }
                    }
                }
                
                
               
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
        
        if indexPath.row > 0 && commentList[indexPath.row - 1].userid == FirebaseManager.shered.getMyUserid() {
            let comment = commentList[indexPath.row - 1]
            print("コメントをタップしました",commentList[indexPath.row - 1].comment)
          
            commentDeleteAlert(commentid: comment.id)
        }
        else if indexPath.row > 0 {
            let comment = commentList[indexPath.row - 1]
            //コメントを通報する
            print("通報する")
            reportAlert(type: "comment", comment: comment)
          
        }
    }
    @objc func report(sender : UIButton){
        alert()
    }
   
    func reportAlert(type:String,comment:Comment?){
        let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
               
            // userid, post id と 報告内容
               let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
                   let report = "嫌がらせ・差別・誹謗中傷"
                   if type == "comment" {
                       FirebaseManager.shered.reportComment(postID: discription!.id, commentid:comment!.id , commenter:comment!.userid,text:comment!.comment,type: report)
                   }
                   else {
                       FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   }
                  
                   print(report)
                   completeAlert(text: "報告が完了しました")
               }
               let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                   let report = "内容が著しく事実と異なる"
                   if type == "comment" {
                       FirebaseManager.shered.reportComment(postID: discription!.id, commentid:comment!.id , commenter:comment!.userid,text:comment!.comment,type: report)
                   }
                   else {
                       FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   }
                  
                   completeAlert(text: "報告が完了しました")
                   print(report)
               }
               let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
                  
                   let report = "性的表現"
                   if type == "comment" {
                       FirebaseManager.shered.reportComment(postID: discription!.id, commentid:comment!.id , commenter:comment!.userid,text:comment!.comment,type: report)
                   }
                   else {
                       FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   }
                  
                   print(report)
                   completeAlert(text: "報告が完了しました")
               }
            let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
                   
                    let report = "不適切な投稿"
                if type == "comment" {
                    FirebaseManager.shered.reportComment(postID: discription!.id, commentid:comment!.id , commenter:comment!.userid,text:comment!.comment,type: report)
                }
                else {
                    FirebaseManager.shered.report(disc: discription!, userid:FirebaseManager.shered.getMyUserid(), category: report)
                }
                    print(report)
                    completeAlert(text: "報告が完了しました")
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
            
            reportAlert(type: "disc", comment: nil)
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
        
        completeAlert(text: "\(profile.username) さんをブロックしました")
        
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
                    StorageManager.shered.deleteDiscriptionImage(image: self.discription!.data)
                }else{
                    StorageManager.shered.deleteDiscriptionVideo(video: discription!.data)
                    cell.videoView.stop()
                }
                
                //前の画面がmapなのかprofileなのかで処理がかわる
           
            if isMapVC {
                print("MapViewController")
                //初めてログインした時だとsignupまで戻ってしまう
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)! - 2] as! MapViewController
                preVC.isReload = true
                completeAlert(text: "削除が完了しました")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                print("profileViewController")
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)! - 2] as! profileViewController
                preVC.isReload = true
                completeAlert(text: "削除が完了しました")
                self.navigationController?.popViewController(animated: true)
            }
                  
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
    }
    func commentDeleteAlert(commentid:String){
        let alert = UIAlertController(title: "報告", message: "削除してもよろしいですか？", preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { [self] _ in
              
                //前の画面がmapなのかprofileなのかで処理がかわる
            FirebaseManager.shered.deleteComment(postID: discription!.id, commentID: commentid)
            completeAlert(text: "返信を削除しました")
        
                  
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension detailViewController:profileCellDelegate {
    func showMenu(disc: Discription, profile: Profile) {
        if disc.userid != FirebaseManager.shered.getMyUserid() {
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            let alertA = UIAlertAction(title: "\(profile.username)さんを通報する", style: .default) {  action in
                print("通報する")
                
            }
            let alertB = UIAlertAction(title: "\(profile.username)さんをブロックする", style: .default) {  action in
                
            }

            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in print("キャンセル")}
              
            myAlert.addAction(alertA)
            myAlert.addAction(alertB)
            myAlert.addAction(cancelAlert)
            
            present(myAlert, animated: true, completion: nil)
        }
        else {
            //自分の投稿
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            let alertA = UIAlertAction(title: "公開範囲を変更する", style: .default) {  action in
                print("公開範囲変更")
                //もし24時間以内ならfrienddiscを変更する
                let vc = FriendListViewController()
                vc.isEditView = true
                vc.disc = disc
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            let alertB = UIAlertAction(title: "投稿を削除する", style: .default) {  action in
                print("投稿を削除する")
            }

            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                   print("キャンセル")
            }
              
            myAlert.addAction(alertA)
            myAlert.addAction(alertB)
            myAlert.addAction(cancelAlert)
            
            present(myAlert, animated: true, completion: nil)
        }
        
    }
    
    func expandVideo(player: AVPlayer) {
        print("videoView")
        let vc = VideoViewController()
        vc.videoView.player = player
       
        vc.videoView.updateSlider()
        if cell.videoView.isStart{
            vc.videoView.isStart = true
            vc.videoView.startButton.isHidden = true
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
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
       
        if profile.userid != FirebaseManager.shered.getMyUserid() {
            print("自分のじゃないよ")
            print(profile)
            vc.isMyProfile = false
        }
        let rootVC = UIApplication.shared.windows.first?.rootViewController as? UITabBarController
        let navigationController = rootVC?.children[1] as? UINavigationController
        rootVC?.selectedIndex = 1
        navigationController?.pushViewController(vc, animated: false)
    }
   
}

extension detailViewController:CommentDelegate {
    func completealert() {
//        cell.videoView.stop()
        getComment()
        completeAlert(text: "送信しました")
    }
    
}
class VideoViewController:UIViewController {
    let videoView = VideoPlayer()
    let backButon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        return button
    }()
    override func viewDidLoad() {
        print("videoViewController")
        view.backgroundColor = .black
        videoView.backgroundColor = .black
        videoView.start()
        videoView.setupSlider()
        videoView.setupVideoTap()
        addConstraint()
    }

      // 画面を回転させるかどうか
    override var shouldAutorotate: Bool {
        return true
    }
    func addConstraint(){
        view.addSubview(videoView)
        view.addSubview(backButon)
        videoView.anchor(top: view.topAnchor, paddingTop: 0,
                         left: view.leftAnchor, paddingLeft: 0,
                         right: view.rightAnchor, paddingRight: 0,
                         bottom: view.bottomAnchor, paddingBottom: 0)
        backButon.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10,
                         left:view.safeAreaLayoutGuide.leftAnchor ,paddingLeft: 10,
                         width: 30,height: 30)
        backButon.addTarget(self, action: #selector(back), for: .touchDown)
    }
    @objc func back(){
        //前の画面に戻る
        print("back")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

//詳
