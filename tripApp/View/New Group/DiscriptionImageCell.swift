//
//  DiscriptionImageCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/30.
//

import Foundation
import UIKit

class DiscriptionImageCell:UICollectionViewCell{
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        self.addSubview(imageView)
        addImageViewConstraint()
    }
    func addImageViewConstraint(){
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo:self.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




