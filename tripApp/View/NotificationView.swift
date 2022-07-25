//
//  NotificationView.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/23.
//

import Foundation
import UIKit

class NotificationView :baseView {
    let iconImage:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let titleLabel = UILabel()
    override func setupViews() {
     
        titleLabel.textAlignment = .left
        iconImage.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    func setView(height:CGFloat,title:String){
        print("height",height)
        addSubview(iconImage)
        addSubview(titleLabel)
    
        iconImage.anchor(top: self.topAnchor, paddingTop: 20,
                         left: self.leftAnchor, paddingLeft: 10,
                         right: titleLabel.leftAnchor, paddingRight:10,
                         width: height - 30 ,height: height - 30 )
        
        titleLabel.anchor(top: self.topAnchor, paddingTop: 5,
                          right: self.rightAnchor, paddingRight: 0,
                          bottom: self.bottomAnchor, paddingBottom: 5)
      
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
       
    }
   
}
