//
//  imageCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/09.
//

import Foundation
import UIKit


class ImageCell:UICollectionViewCell{
    override var isSelected: Bool{
           didSet{
//               menuTitle.textColor =  isSelected ? .white : .black
//               menuTitle.backgroundColor = isSelected ? .darkGray : .systemGray5
            imageView.alpha = isSelected ? 0.5 : 1.0
           }
          
       }
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        self.addSubview(imageView)
        addImageViewConstraint()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
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



