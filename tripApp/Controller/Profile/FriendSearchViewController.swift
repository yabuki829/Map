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
                if profile?.profileImageUrl == "person.crop.circle.fill"{
                    profileImage.image = UIImage(named: "person.crop.circle.fill")
                }
                else{
                    profileImage.setImage(urlString: profile!.profileImageUrl)
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
    
    func addConstraint(){
        
        view.addSubview(textField)
        view.addSubview(profileImage)
        view.addSubview(usernameLabel)
        view.addSubview(followButton)
        view.addSubview(messageLabel)
        
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
        if profile?.userid != "" || profile?.userid.isEmpty == false{
            print("Followします")
            FollowManager.shere.follow(userid: profile!.userid)
            FirebaseManager.shered.follow(friendid: profile!.userid)
            followButton.setTitle("友達になりました", for: .normal)
            followButton.isEnabled = false
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
        HUD.show(.progress)
        FirebaseManager.shered.getUserID(userid: textField.text!) { (userid) in
            print("userid 取得完了")
            HUD.hide()
            if userid == "idが正しくありません"{
              
                self.messageLabel.textAlignment = .left
                self.messageLabel.text = "入力したFriendIDが正しくない、もしくは存在しないFriendIDです"
                self.messageLabel.isHidden = false
                return
                
            }
            else if userid == FirebaseManager.shered.getMyUserid(){
                self.messageLabel.text = "ご自身のアカウントです"
                self.messageLabel.textAlignment = .center
                self.messageLabel.isHidden = false
                return
            }
            else{
                FirebaseManager.shered.getProfile(userid: userid) { (data) in
                    print("取得完了")
                    print(data)
                    if data.userid == "error"{
                        self.messageLabel.text = "Profileが設定されていないUserです"
                        self.messageLabel.textAlignment = .center
                        self.messageLabel.isHidden = false
                    }
                    else{
                        self.profile = data
                    }
                    
                  
                }
            }
          
        }
        
        return true
    }
    
   
   
}

class AlertManager{
    static let shared = AlertManager()
    func showFriendID() -> UIAlertController{
           
           let id = UserDefaults.standard.object(forKey: "userid")
           let alert = UIAlertController(title: "your FriendID" , message:id as? String, preferredStyle: .alert)

           let selectAction = UIAlertAction(title: "Copy", style: .default, handler: { _ in
               let pasteboard = UIPasteboard.general
               pasteboard.string = id as? String

                 let generator = UISelectionFeedbackGenerator()
                 generator.prepare()
                 generator.selectionChanged()
              
           })
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

           alert.addAction(selectAction)
           alert.addAction(cancelAction)
           return alert
       
       }
}
