//
//  DetailCell.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/04.
//

import Foundation
import UIKit

class DetailViewCell: UITableViewCell {
    var discription: Discription?{
        didSet{
            discTextLabel.text = discription?.text
            dateLabel.text = discription?.created.covertString()
            
        }
    }
    var profile:Profile?{
        didSet{
            profileImageView.setImage(urlString: profile!.profileImageUrl)
            usernameButton.setTitle(profile?.username, for: .normal)
            
        }
    }
    let discImageView = UIImageView()
    let discTextLabel = UILabel()
    let dateLabel     = UILabel()
    let videoView:VideoPlayer = {
        let view = VideoPlayer()
        return view
    }()
    let profileImageView = UIImageView()
    let usernameButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        return button
    }()
    
    var width = CGFloat()
    //navgaitonbar,tabbar,の高さ
    var subHeight = CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    func setCell(disc:Discription,widthSize:CGFloat,heightSize:CGFloat){
        width = widthSize
        subHeight = heightSize
        discription = disc
        addView()
        getProfile()
        if disc.type == "image"{
            discImageView.setImage(urlString:disc.image.url )
            discImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage)))
        }
        else{
            videoView.loadVideo(urlString: disc.image.url)
            videoView.setup()
            videoView.setupVideoTap()
        }
        usernameButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUserIconOrUsername)))
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUserIconOrUsername)))
     
    }
    func getProfile(){
        FirebaseManager.shered.getProfile(userid: discription!.userid) { [self] (result) in
            profile = result
        }
    }
    func addView(){
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameButton)
        contentView.addSubview(discTextLabel)
        contentView.addSubview(dateLabel)
        if discription?.type == "image" {
            contentView.addSubview(discImageView)
            discImageView.backgroundColor = .black
            discImageView.isUserInteractionEnabled = true
            discImageView.contentMode = .scaleAspectFit
            discImageView.anchor(left: contentView.leftAnchor, paddingLeft: 5.0,
                                 right: contentView.rightAnchor, paddingRight: 5.0,
                                 bottom: contentView.bottomAnchor,paddingBottom: 10,
                                 height: width - 10)
         
            dateLabel.anchor(top:discTextLabel.bottomAnchor , paddingTop: 2.0,
                             left: contentView.leftAnchor, paddingLeft: 10.0,
                             right: contentView.rightAnchor, paddingRight: 10.0,
                             bottom: discImageView.topAnchor,paddingBottom: 10)
        }
        else{
            contentView.addSubview(videoView)
           
            print("heigthhhhhhhhhhhhhh",subHeight)
            videoView.anchor(left: contentView.leftAnchor, paddingLeft: 0,
                                 right: contentView.rightAnchor, paddingRight: 0,
                                 bottom: contentView.bottomAnchor,paddingBottom: 10,
                                 height: width)
            dateLabel.anchor(top:discTextLabel.bottomAnchor , paddingTop: 2.0,
                             left: contentView.leftAnchor, paddingLeft: 10.0,
                             right: contentView.rightAnchor, paddingRight: 10.0,
                             bottom: videoView.topAnchor,paddingBottom: 10)
        }
       
        profileImageView.layer.cornerRadius = width / 7 / 2
        profileImageView.clipsToBounds = true
        profileImageView.anchor(top: contentView.topAnchor, paddingTop: 10,
                                left: contentView.leftAnchor, paddingLeft: 10,
                                width: width / 7,
                                height:  width / 7)
        profileImageView.isUserInteractionEnabled = true
        usernameButton.anchor(top: contentView.topAnchor, paddingTop: 10,
                             left: profileImageView.rightAnchor, paddingLeft: 10,
                              right: contentView.rightAnchor, paddingRight: 10.0,
                             height: width / 7)
        usernameButton.contentHorizontalAlignment = .left
        
    
        
        
        discTextLabel.font = UIFont.systemFont(ofSize: 20)
        discTextLabel.backgroundColor = .white
        discTextLabel.numberOfLines = 0
        discTextLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 5.0,
                             left: leftAnchor, paddingLeft: 10.0,
                             right: contentView.rightAnchor, paddingRight: 10.0)
        
       
        
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.tintColor = .systemGray5
        dateLabel.textAlignment = .right
     
       
      
      
        
        
        
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
