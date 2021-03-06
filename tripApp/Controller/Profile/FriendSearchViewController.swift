//
//  FriendSearchViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/25.
//

import Foundation
import UIKit
import PKHUD
class FriendSearchViewController:UIViewController, UITextFieldDelegate{
    
    var profile: Profile?{
        didSet{
            //自分のprofileじゃない　かつ　フォローしていない
            if FollowManager.shere.isME(userid: profile!.userid) == false && FollowManager.shere.isFollow(userid: profile!.userid) == false{
                followButton.isHidden = false
                messageLabel.isHidden = true
                if profile?.profileImage.url == "person.crop.circle.fill"{
                    profileImage.image = UIImage(systemName: "person.crop.circle.fill")
                }
                else{
                    profileImage.setImage(urlString: profile!.profileImage.url)
                }
                if profile?.username == ""{
                    usernameLabel.text = "No Name"
                }
                else{
                    usernameLabel.text = profile?.username
                }
            }
            else{
                messageLabel.isHidden = false
                messageLabel.text = "ご自身のアカウントもしくは友達のアカウントです"
            }
         
           
            
        }
    }
    
    let explainTextView:UITextView = {
        let label = UITextView()
        label.text =
        "< 注意 > \n 友達同士にならないと投稿は表示されません。友達にFriendIDを教えてもらいましょう"
        label.backgroundColor = .clear
        label.isEditable = false
        return label
    }()
    
    let profileImage:UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        return imageview
    }()
    let usernameLabel:UILabel = {
        let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    let textField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "FriendIDを入力してください"
        textfield.autocorrectionType = .no
        return textfield
    }()
    
    let followButton:UIButton = {
        let button = UIButton()
        button.setTitle("友達になる", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .link
        return button
    }()
    let messageLabel:UILabel = {
        let label = UILabel()
        label.text = "存在しないFriendIDです"
        label.numberOfLines = 0
        
        return label
    }()
    let adView = AdBannerView()
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
                return true
    }
    override func viewDidLoad() {
        self.view.backgroundColor = .white
  
        print("友達検索画面")
        addConstraint()
        setNav()
        textField.resignFirstResponder()
        followButton.addTarget(self, action: #selector(Follow(sender:)), for: .touchUpInside)
        followButton.isHidden = true
    }
    func alert(){
        let myAlert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
               
            let alertA = UIAlertAction(title: "友達を整理する", style: .default) {  action in
                //友達リストに遷移する
                let vc = FriendListViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let alertC = UIAlertAction(title: "キャンセル", style: .default) {  action in
             
                
            }
        myAlert.addAction(alertA)
        myAlert.addAction(alertC)
        present(myAlert, animated: true, completion: nil)
    }

    func setNav(){
        self.title = "友達検索"
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
        
        let showFriendIdItem = UIBarButtonItem(title: "FriendID", style: .plain, target: self, action: #selector(showFriendId))
        showFriendIdItem.tintColor = .link
        navigationItem.rightBarButtonItem = showFriendIdItem
    }
    @objc func back(sender : UIButton){
        print("Back")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc internal func Follow(sender: UIButton) {
        print("Follow")
        //userdefaultsにuseridを保存する
        //フレンドの人数を確認 10人いれば　サブスク画面に遷移する
        
        if profile?.userid != "" || profile?.userid.isEmpty == false{
            print("Followします")
            FollowManager.shere.follow(userid: profile!.userid)
            FirebaseManager.shered.follow(friendid: profile!.userid)
            followButton.setTitle("友達です", for: .normal)
            followButton.isEnabled = false
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    @objc func showFriendId(){
        print("Show Friend ID")
        present(AlertManager.shared.showFriendID(), animated: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            return false
        }
        textField.text = textField.text!.trimmingCharacters(in: .whitespaces)
        let userid = textField.text ?? "エラー"
            FirebaseManager.shered.getProfile(userid: userid ) { (data) in
                print("取得完了")
                print(data)
                if data.userid == "error"{
                    self.messageLabel.text = "Profileが設定されていない。もしくは,削除されたUserです"
                    self.messageLabel.textAlignment = .center
                    self.messageLabel.isHidden = false
                }
                else{
                    self.profile = data
                }
                    
                  
            }
            
        return true
    }
    
   
   
}

extension FriendSearchViewController {
    func addConstraint(){
        
        view.addSubview(textField)
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(followButton)
        view.addSubview(messageLabel)
        view.addSubview(explainTextView)
        view.addSubview(adView)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        textField.delegate = self
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10 ).isActive = true
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 2 - view.frame.width / 4 / 2).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.layer.cornerRadius = view.frame.width / 4 / 2
        profileImage.clipsToBounds = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true
        followButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 120).isActive = true
        followButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -120).isActive = true
        
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 100).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        messageLabel.isHidden = true
        
        explainTextView.anchor(top: messageLabel.bottomAnchor, paddingTop: 10,
                               left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 10,
                               right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                               height: 100)
        adView.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 30,width: 300, height: 250)
        adView.centerX(inView: view)
    }
}
class AlertManager{
    static let shared = AlertManager()
    func showFriendID() -> UIAlertController{
           
        let id = FirebaseManager.shered.getMyUserid()
           let alert = UIAlertController(title: "your FriendID" , message:id , preferredStyle: .alert)

           let selectAction = UIAlertAction(title: "Copy", style: .default, handler: { _ in
               let pasteboard = UIPasteboard.general
               pasteboard.string = id

                 let generator = UISelectionFeedbackGenerator()
                 generator.prepare()
                 generator.selectionChanged()
              
           })
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

           alert.addAction(selectAction)
           alert.addAction(cancelAction)
           return alert
       
       }
    func shewMessage(title:String?,message:String?) -> UIAlertController{
        let alert = UIAlertController(title: title! , message: message!, preferredStyle: .alert)

        let selectAction = UIAlertAction(title: "ok", style: .default, handler: nil)
       

        alert.addAction(selectAction)
        return alert
    }
}


//
//  AdView.swift
//  tripApp
//
//  Created by 薮木翔大 on 2022/07/30.
//
//
//import Foundation
//import UIKit
import NendAd


class AdBannerView:baseView ,NADViewDelegate{
    let nadView = NADView()
    override func setupViews() {
        nadView.delegate = self
        self.addSubview(nadView)
        nadView.anchor(top: self.topAnchor, paddingTop: 0,
                      left: self.leftAnchor, paddingLeft: 0,
                      right: self.rightAnchor, paddingRight: 0,
                      bottom: self.bottomAnchor, paddingBottom: 0)
        settingAD()
    }
    func settingAD(){
        nadView.setNendID(70356, apiKey: "88d88a288fdea5c01d17ea8e494168e834860fd6")
//        nadView.setNendID(1063088, apiKey: "e79df9fa09f57f798884caa0b172f834398d8a9a")
        nadView.load()
    }
    func nadViewDidFinishLoad(_ adView: NADView!) {
        print("ロード完了")
    }
    func nadViewDidReceiveAd(_ adView: NADView!){
        print("受信をしました")
    }
    func nadViewDidFail(toReceiveAd adView: NADView!) {
           
           // エラーごとに処理を分岐する場合
        let error: NSError = adView.error as NSError
        print(error)
        switch (error.code) {
        case NADViewErrorCode.NADVIEW_AD_SIZE_TOO_LARGE.rawValue:
            print("広告サイズがディスプレイサイズよりも大きい")
            break
        case NADViewErrorCode.NADVIEW_INVALID_RESPONSE_TYPE.rawValue:
            print(" 不明な広告ビュータイプ")
            break
        case NADViewErrorCode.NADVIEW_FAILED_AD_REQUEST.rawValue:
            print("広告取得失敗")
            break
        case NADViewErrorCode.NADVIEW_FAILED_AD_DOWNLOAD.rawValue:
            print(" 広告画像の取得失敗")
            break
        case NADViewErrorCode.NADVIEW_AD_SIZE_DIFFERENCES.rawValue:
            print(" リクエストしたサイズと取得したサイズが異なる")
            break
        default:
            print("その他")
            break
        }
    }
}
