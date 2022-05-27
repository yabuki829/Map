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
        userImageView.loadImageUsingUrlString(urlString: imageurl)
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
