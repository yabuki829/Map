//
//  FriendListCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/27.
//

import Foundation
import UIKit

class FriendListCell:BaseCell{
    let userImageView:UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        return label
    }()
    
    override func setupViews() {
        self.addSubview(userImageView)
        self.addSubview(usernameLabel)
        self.addSubview(textLabel)
        addConstraint()
        settingUserImageView()
    }
    func setCell(imageurl:String,username:String,text:String){
        if imageurl != "" || imageurl.isEmpty == false {
//            userImageView.loadImageUsingUrlString(urlString: imageurl)
            userImageView.setImage(urlString: imageurl)
        }
        usernameLabel.text = username
        textLabel.text = text
    }
    func addConstraint(){
        userImageView.anchor(top:self.safeAreaLayoutGuide.topAnchor,paddingTop: 0,  left: self.leftAnchor,paddingLeft: 10, bottom: self.bottomAnchor,paddingBottom: 0,  width:self.frame.height , height:self.frame.height)
        
        usernameLabel.anchor(top:self.safeAreaLayoutGuide.topAnchor,paddingTop: 5,left: userImageView.rightAnchor,paddingLeft: 10,right: self.rightAnchor,paddingRight: 10)
        textLabel.anchor(top:usernameLabel.bottomAnchor,paddingTop:0,left: userImageView.rightAnchor,paddingLeft: 10,right: self.rightAnchor,paddingRight: 10,bottom: self.bottomAnchor,paddingBottom: 5)
        
    }
    func settingUserImageView(){
        userImageView.layer.cornerRadius = self.frame.height / 2
        userImageView.clipsToBounds = true
    }
}


class FriendListWithPostCell :BaseCell{
    let userImageView:UIImageView = {
        let imageview = UIImageView()
    
        return imageview
    }()
    let usernameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let isSendButton : UIButton = {
        let button = UIButton()
        button.setTitle("送信しない", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 8.0)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    var index = Int()
    var isSend = false
    var friend = Friend(userid: "")
    override func setupViews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(isSendButton)
        isSendButton.addTarget(self, action: #selector(showFriendListView(sender:)), for: .touchUpInside)
        addConstraint()
        settingUserImageView()
    }
    func setCell(imageurl:String,username:String,friend:Friend,index: Int){
        self.friend = friend
    
        
        if friend.isSend {
            isSendButton.setTitle("送信する", for: .normal)
            isSendButton.backgroundColor = .darkGray
            isSendButton.setTitleColor(.white, for: .normal)
            
        }
        
        if imageurl != "" || imageurl.isEmpty == false {
            userImageView.setImage(urlString: imageurl)
        }
        usernameLabel.text = username
        self.index = index
    }
    func addConstraint(){
        userImageView.anchor(top: safeAreaLayoutGuide.topAnchor,paddingTop: 0,
                             left: leftAnchor,paddingLeft: 10,
                             bottom: self.bottomAnchor,paddingBottom: 0,
                             width: frame.height , height: frame.height)
        
        usernameLabel.anchor(top:self.safeAreaLayoutGuide.topAnchor,paddingTop: 5,
                             left: userImageView.rightAnchor,paddingLeft: 10,
                             right: isSendButton.leftAnchor,paddingRight: 10,
                             bottom: safeAreaLayoutGuide.bottomAnchor,paddingBottom: 5)
        
        isSendButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 20,
                            right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                            bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20,
                            width: frame.width / 4,
                            height: frame.height - 40)
        
    }
    func settingUserImageView(){
        userImageView.layer.cornerRadius = self.frame.height / 2
        userImageView.clipsToBounds = true
    }
    @objc func showFriendListView(sender: UIButton){
        print("tapppppppp")
        friend.isSend = !friend.isSend
        FollowManager.shere.changeisSend(friend: friend)
        
        if friend.isSend {
            isSendButton.setTitle("送信する", for: .normal)
            isSendButton.backgroundColor = .darkGray
            isSendButton.setTitleColor(.white, for: .normal)
            
        }
        else{
           
            isSendButton.setTitle("送信しない", for: .normal)
            isSendButton.backgroundColor = .lightGray
            isSendButton.setTitleColor(.white, for: .normal)
        }
        print(index)
        
    }
}

