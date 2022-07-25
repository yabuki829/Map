//
//  CommentCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit



class commentCell:BaseTableViewCell{
    var width = CGFloat()
    var commentdata = Comment(id: "", comment: "", userid: "", created: Date())
    var profile:Profile?{
        didSet{
            profileimageView.setImage(urlString:profile!.profileImage.url )
            usernameLabel.text = profile?.username
            
        }
    }
    let profileimageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return  label
    }()
    let commentLabel:UILabel = {
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
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 10)
        return  label
    }()
  

    override func setupViews(){
        print("setupViews")
        self.addSubview(profileimageView)
        self.addSubview(usernameLabel)
        self.addSubview(commentLabel)
        self.addSubview(dateLabel)
        
    }
  
    func setCell(comment:Comment,size:CGFloat){
        width = size
        addConstraint()
        commentdata = comment
       
        commentLabel.text = commentdata.comment
        dateLabel.text = commentdata.created.secondAgo()
        getProfile()
    }
    func addConstraint(){
        profileimageView.anchor(top: topAnchor, paddingTop: 20,
                                left: leftAnchor , paddingLeft: 30,
                                width: width / 10, height: width / 10)
        profileimageView.layer.cornerRadius = width / 10 / 2
        profileimageView.clipsToBounds = true
        usernameLabel.anchor(top: topAnchor, paddingTop: 20,
                             left: profileimageView.rightAnchor, paddingLeft: 10,
                             height: width / 30 )
        
        dateLabel.anchor(top: topAnchor, paddingTop: 20,
                          left: usernameLabel.rightAnchor, paddingLeft: 0,
                          right: rightAnchor, paddingRight: 10,
                          height: width / 30)
        
        commentLabel.anchor(top: usernameLabel.bottomAnchor, paddingTop: 5,
                            left: profileimageView.rightAnchor, paddingLeft: 10,
                            right: rightAnchor, paddingRight: 10,
                            bottom: bottomAnchor, paddingBottom: 20)
        
      
    }
    func getProfile(){
        FirebaseManager.shered.getProfile(userid: commentdata.userid) { [self] (result) in
            profile = result
        }
        
    }
}
