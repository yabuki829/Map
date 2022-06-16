//
//  CommentCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

class DetailViewCell: UITableViewCell {
    var discription: Discription?{
        didSet{
            titleLabel.text  = discription?.title
            discTextLabel.text = discription?.text
            dateLabel.text = discription?.created.covertString()
            
        }
    }
    var profile:Profile?{
        didSet{
            profileImageView.loadImageUsingUrlString(urlString: profile!.profileImageUrl)
            usernameButton.setTitle(profile?.username, for: .normal)
            
        }
    }
    let discImageView = UIImageView()
    let titleLabel    = UILabel()
    let discTextLabel = UILabel()
    let dateLabel     = UILabel()
    
    let profileImageView = UIImageView()
    let usernameButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        return button
    }()
    
    var width = CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func setCell(disc:Discription,size:CGFloat,image:UIImage){
        width = size
        discription = disc
        addView()
        getProfile()
        discImageView.image = image
        usernameButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUserIconOrUsername)))
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUserIconOrUsername)))
        discImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
    }
    func getProfile(){
        FirebaseManager.shered.getProfile(userid: discription!.userid) { [self] (result) in
            profile = result
        }
    }
    func addView(){
        
        addSubview(profileImageView)
        addSubview(usernameButton)
        addSubview(titleLabel)
        addSubview(discTextLabel)
        addSubview(dateLabel)
        addSubview(discImageView)
        
        profileImageView.layer.cornerRadius = width / 7 / 2
        profileImageView.clipsToBounds = true
        profileImageView.anchor(top: topAnchor, paddingTop: 10,
                                left: leftAnchor, paddingLeft: 10,
                                width: width / 7,
                                height:  width / 7)
        profileImageView.isUserInteractionEnabled = true
        usernameButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 10,
                             left: profileImageView.rightAnchor, paddingLeft: 10,
                             right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10.0,
                             height: width / 7)
        usernameButton.contentHorizontalAlignment = .left
        
       
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleLabel.anchor(top:profileImageView.bottomAnchor , paddingTop: 5.0,
                          left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 5.0,
                          right: safeAreaLayoutGuide.rightAnchor, paddingRight: 5.0)
        
        
        discTextLabel.font = UIFont.systemFont(ofSize: 18)
        discTextLabel.backgroundColor = .white
        discTextLabel.numberOfLines = 0
        discTextLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 0.0,
                             left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 10.0,
                             right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10.0)
        
       
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.tintColor = .systemGray5
        dateLabel.textAlignment = .right
        dateLabel.anchor(top:discTextLabel.bottomAnchor , paddingTop: 2.0,
                         left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 10.0,
                         right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10.0,
                         bottom: discImageView.topAnchor,paddingBottom: 10)
       
        discImageView.backgroundColor = .black
        discImageView.contentMode = .scaleAspectFit
        discImageView.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 5.0,
                             right: safeAreaLayoutGuide.rightAnchor, paddingRight: 5.0,
                             bottom: bottomAnchor,paddingBottom: 10,
                             height: width)
        discImageView.isUserInteractionEnabled = true
      
        
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @objc func tapImage(){
        if discImageView.image != nil{
            delegate?.toDetail(image:discImageView.image!)
        }
       
    }
    @objc func tapUserIconOrUsername(){
        delegate?.toProfilePage()
    }
    
    weak var delegate:profileCellDelegate? = nil
}
protocol profileCellDelegate: class  {
    func toDetail(image:UIImage)
    func toProfilePage()
}




class commentCell:BaseTableViewCell{
    var width = CGFloat()
    var commentdata = Comment(id: "", comment: "", userid: "", created: Date())
    var profile:Profile?{
        didSet{
            profileimageView.loadImageUsingUrlString(urlString:profile!.profileImageUrl)
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
        dateLabel.text = commentdata.created.covertString()
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
