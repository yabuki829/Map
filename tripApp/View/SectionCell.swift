//
//  SectionCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/12.
//

import Foundation
import UIKit

class SectionCell :BaseCell{
    

    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "開発者のその他アプリ"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
  
    override func setupViews() {
        addSubview(titleLabel)
        self.backgroundColor = .systemGray5
        addtitleConstraint()
    }
   
   
    func addtitleConstraint(){
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}
