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
        label.font =  UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("削除する", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    var userID = String()
    var isDelete = false
    var isBlockList = false
    var isBlock = true
    override func setupViews() {
      
        settingUserImageView()
    }
    func setCell(imageurl:String,username:String,text:String,userid:String){
        addConstraint()
        if imageurl == "person.crop.circle.fill" {
            userImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        else{
            userImageView.setImage(urlString: imageurl)
        }
        if isBlockList {
            print("解除する")
            deleteButton.setTitle("解除する", for: .normal)
        }
  
        usernameLabel.text = username
        textLabel.text = text
        userID = userid
        
    }
    func addConstraint(){
        self.addSubview(userImageView)
        self.addSubview(usernameLabel)
      
        self.addSubview(deleteButton)
        userImageView.anchor(top:self.safeAreaLayoutGuide.topAnchor,paddingTop: 0,  left: self.leftAnchor,paddingLeft: 10, bottom: self.bottomAnchor,paddingBottom: 0,  width:self.frame.height , height:self.frame.height)
        
        usernameLabel.anchor(top:self.safeAreaLayoutGuide.topAnchor,paddingTop: 5,
                             left: userImageView.rightAnchor,paddingLeft: 10,
                             right: self.deleteButton.leftAnchor,paddingRight: 10)
        if isBlockList {
            print("A")
            usernameLabel.anchor(bottom:self.safeAreaLayoutGuide.bottomAnchor ,paddingBottom: 5)
            deleteButton.anchor( right:self.rightAnchor,paddingRight: 10,
                                width: 80,height: 30)
            deleteButton.centerY(inView: self)
            deleteButton.addTarget(self, action: #selector(unBlock(sender:)), for: .touchUpInside)
        }
        else{
            print("B")
            self.addSubview(textLabel)
            textLabel.anchor(top:usernameLabel.bottomAnchor,paddingTop:0,
                             left: userImageView.rightAnchor,paddingLeft: 10,
                             right: self.deleteButton.leftAnchor,paddingRight: 10,
                             bottom: self.bottomAnchor,paddingBottom: 5,height: 30)
            deleteButton.anchor( right:self.rightAnchor,paddingRight: 10,
                                width: 80,height: 30)
            deleteButton.centerY(inView: self)
            deleteButton.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        }
        
      
        
        
    }
    func settingUserImageView(){
        userImageView.layer.cornerRadius = self.frame.height / 2
        userImageView.clipsToBounds = true
    }
    @objc func unBlock(sender: UIButton){
        print("unBlock")
       
        isBlock = !isBlock
        if isBlock {
            FollowManager.shere.block(userid: userID)
            deleteButton.setTitle("解除する", for: .normal)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.setTitleColor(.lightGray, for: .highlighted)
            deleteButton.backgroundColor = .link
        }
        else{
            FollowManager.shere.unBlock(userid: userID)
            deleteButton.setTitle("ブロックする", for: .normal)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.setTitleColor(.lightGray, for: .highlighted)
            deleteButton.backgroundColor = .lightGray
        }
    }
    @objc  func delete(sender: UIButton){
        isDelete = !isDelete
        if isDelete {
            //削除
            FollowManager.shere.unfollow(userid: userID)
            FirebaseManager.shered.unfollow(friendid: userID)
            deleteButton.setTitle("追加する", for: .normal)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.setTitleColor(.lightGray, for: .highlighted)
            deleteButton.backgroundColor = .link
        }
        else{
            //もう一度追加する
            FollowManager.shere.follow(userid: userID)
            FirebaseManager.shered.follow(friendid: userID)
            deleteButton.setTitle("削除する", for: .normal)
            deleteButton.setTitleColor(.white, for: .normal)
            deleteButton.setTitleColor(.lightGray, for: .highlighted)
            deleteButton.backgroundColor = .lightGray
        }
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

