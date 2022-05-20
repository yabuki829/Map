//
//  CommentCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

class CommentCell:BaseCell{
  
    let topimageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return  label
    }()
    let textLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return  label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10)
        return  label
    }()
    var maxWidth = CGFloat()
    override func setupViews() {
        print("a")
        self.addSubview(topimageView)
        self.addSubview(usernameLabel)
        self.addSubview(textLabel)
        self.addSubview(dateLabel)
    }
}

//左に画像
class PartnerCommentCell:CommentCell{
    
  
    func addConstraints(){
        print("b")
        let imageWidth  = floor(maxWidth / 8)
        self.frame.size.width = maxWidth
        topimageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        topimageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        
        topimageView.widthAnchor.constraint(equalToConstant: imageWidth - 2).isActive  = true
        topimageView.heightAnchor.constraint(equalToConstant: imageWidth - 2).isActive  = true
        topimageView.layer.cornerRadius = imageWidth / 2 - 2
        
        topimageView.clipsToBounds = true
        // 5 + (imageWidth - 2) + 5 + textLabel.width +  0 = maxWidth
        // textlabel.width =  maxwidth - 5 -(imageWidth - 2) - 5
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
   
        textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2).isActive = true
        textLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        textLabel.widthAnchor.constraint(equalToConstant:  maxWidth - 5 - (imageWidth - 2) - 5).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
    }
    func setCell(username:String,text:String,date:Date,image:String,width:CGFloat){
        usernameLabel.text = username
        textLabel.text = text
        dateLabel.text = date.covertString()
        topimageView.image = UIImage(named: image)
        maxWidth = width
        addConstraints()
    }
  
}


//右に画像
class MyCommentCell:CommentCell{
    func addConstraints(){
       
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
       
        
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func setCell(text:String,date:Date){
        //textが二行以上になるならleft
        textLabel.textAlignment = .right
        textLabel.text = text
        dateLabel.text = date.covertString()
        
        addConstraints()
    }
}

//"<NSLayoutConstraint:0x600000e15040 H:|-(5)-[UIImageView:0x7f9bf5daff40](LTR)   (active, names: '|':tripApp.PartnerCommentCell:0x7f9bf5db0850 )>"
//"<NSLayoutConstraint:0x600000e16120 UIImageView:0x7f9bf5daff40.width == 48   (active)>"
//"<NSLayoutConstraint:0x600000e15bd0 H:[UIImageView:0x7f9bf5daff40]-(5)-[UILabel:0x7f9bf5daed90](LTR)   (active)>"
//"<NSLayoutConstraint:0x600000e159a0 UILabel:0x7f9bf5daed90.right == tripApp.PartnerCommentCell:0x7f9bf5db0850.right   (active)>"
//"<NSLayoutConstraint:0x600000e15900 UILabel:0x7f9bf5daed90.width == 348.6   (active)>"
//"<NSLayoutConstraint:0x600000e37a20 'UIView-Encapsulated-Layout-Width' tripApp.PartnerCommentCell:0x7f9bf5db0850.width == 406.667   (active)>"

/*
 
 UIImageViewのwidth
 uiimageviewとuilabelの5
 
 
 
 
 
 **/
