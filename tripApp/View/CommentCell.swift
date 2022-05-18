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
        label.font = UIFont.systemFont(ofSize: 20)
        return  label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 10)
        return  label
    }()
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
        topimageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        topimageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -5).isActive = true
        topimageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        topimageView.widthAnchor.constraint(equalToConstant: self.frame.height - 4).isActive  = true
       
        topimageView.layer.cornerRadius = self.frame.height / 2 - 4
        
        topimageView.clipsToBounds = true
        
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
   
        textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0).isActive = true
        textLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
       
        
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: topimageView.rightAnchor, constant: 5).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
    func setCell(username:String,text:String,date:Date,image:String){
        usernameLabel.text = username
        textLabel.text = text
        dateLabel.text = date.covertString()
        topimageView.image = UIImage(named: image)
        addConstraints()
    }
  
}


//右に画像
class MyCommentCell:CommentCell{
    func addConstraints(){
        
    }
}
