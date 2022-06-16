//
//  ProfileCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/30.
//

import Foundation
import UIKit

class ProfileCell: BaseCell{
    let backgroundImage = UIImageView()
    let profileImage = UIImageView()
    let usernameLabel = UILabel()
    let textLabel = UILabel()
    weak var delegate:transitionDelegate? = nil
    let postStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .fill
        return stackview
    }()
    let friendStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .fill
        return stackview
    }()
    var postCountLabel = UILabel()
    var friendCountLabel = UILabel()
    
    override func setupViews() {
        addSubview(backgroundImage)
        backgroundImage.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 0.0,
                               left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 0.0,
                               right: safeAreaLayoutGuide.rightAnchor, paddingRight: 0.0,
                               width: self.frame.width, height: self.frame.width / 2)
        
        addSubview(profileImage)
        let profileImageSize = frame.width / 4
        profileImage.anchor(top: backgroundImage.bottomAnchor, paddingTop: -profileImageSize / 2 ,
                            left:safeAreaLayoutGuide.leftAnchor , paddingLeft: frame.width / 2 - profileImageSize / 2 ,
                            width: profileImageSize, height: profileImageSize)
        profileImage.layer.cornerRadius = profileImageSize / 2
        profileImage.backgroundColor = .white
        profileImage.clipsToBounds = true
        
        addSubview(usernameLabel)
        usernameLabel.textAlignment = .center
        usernameLabel.anchor(top: profileImage.bottomAnchor, paddingTop: 0.0,
                             left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 10,
                             right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                             height: 50)
        
        addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        textLabel.textColor = .darkGray
        textLabel.anchor(top: usernameLabel.bottomAnchor, paddingTop: 0.0,
                         left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 10,
                         right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                         bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0.0)
        
        addSubview(postStackView)
        postStackView.anchor(top: backgroundImage.bottomAnchor, paddingTop: 20,
                             left: safeAreaLayoutGuide.leftAnchor,paddingLeft: 0,
                             right: profileImage.leftAnchor, paddingRight: 0)
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(tapPost(sender:)))
        postStackView.addGestureRecognizer(tapPost)
        
        addSubview(friendStackView)
        friendStackView.anchor(top: backgroundImage.bottomAnchor, paddingTop: 20,
                               left: profileImage.rightAnchor, paddingLeft: 0,
                               right: safeAreaLayoutGuide.rightAnchor, paddingRight:0)
        let tapFriend = UITapGestureRecognizer(target: self, action: #selector(tapFriendList(sender:)))
        friendStackView.addGestureRecognizer(tapFriend)

        postCountLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        postCountLabel.textAlignment = .center
        postCountLabel.textColor = .link

        let subtitle1 = UILabel()
        subtitle1.text = "Posts"
        subtitle1.font = UIFont.boldSystemFont(ofSize: 12.0)
        subtitle1.textAlignment = .center
        subtitle1.textColor = .link

        
        postStackView.addArrangedSubview(postCountLabel)
        postStackView.addArrangedSubview(subtitle1)
        
        friendCountLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        friendCountLabel.textAlignment = .center
        friendCountLabel.textColor = .link

        let subtitle2 = UILabel()
        subtitle2.text = "Friend"
        subtitle2.font = UIFont.boldSystemFont(ofSize: 12.0)
        subtitle2.textAlignment = .center
        subtitle2.textColor = .link
        
        friendStackView.addArrangedSubview(friendCountLabel)
        friendStackView.addArrangedSubview(subtitle2)
    }
    
    //friendのprofileを表示する
    func setCellB(profile:Profile,followList:[String],postList:[Discription]){
        
        if profile.backgroundImageUrl == "background"  {
            backgroundImage.image = UIImage(named: "background")
        }
        else{
            backgroundImage.loadImageUsingUrlString(urlString: profile.backgroundImageUrl)
        }
       
        if profile.profileImageUrl == "person.crop.circle.fill"{
            profileImage.image = UIImage(systemName: "person.crop.circle.fill")
        }
        else{
            profileImage.loadImageUsingUrlString(urlString: (profile.profileImageUrl))
        }
       
        friendCountLabel.text = String(followList.count)
        postCountLabel.text = String(postList.count)
        usernameLabel.text = profile.username
        textLabel.text = profile.text
        //自分の投稿でなければFriendListへの遷移をさせない
        friendStackView.isUserInteractionEnabled = false
    }
    //自分のprofileを表示する
    func setCellA(profile:myProfile, followList:[String],postList:[Discription]){
        
        if profile.backgroundImage.name == "background"  {
            backgroundImage.image = UIImage(named: "background")
        }
        else{
            backgroundImage.image = UIImage(data: profile.backgroundImage.imageData)
        }
        if profile.profileImage.name == "person.crop.circle.fill"  {
            profileImage.image = UIImage(systemName: "person.crop.circle.fill")
        }
        else{
            profileImage.image = UIImage(data:profile.profileImage.imageData)
        }
        
        friendCountLabel.text = String(followList.count)
        postCountLabel.text = String(postList.count)
        usernameLabel.text = profile.username
        textLabel.text = profile.text
    }
    
    @objc internal func tapFriendList(sender:UITapGestureRecognizer ){
        print("友達一覧に遷移する")
        //友達一覧に遷移する Delegate
        delegate?.toFriendList()
    }
    @objc internal func tapPost(sender:UITapGestureRecognizer ){
        print("投稿一覧")
        delegate?.scroll()
    }
}
