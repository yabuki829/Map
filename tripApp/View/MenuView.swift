//
//  MenuView.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/27.
//

import Foundation
import UIKit

class MenuView:UIView{
    let mapSateliteButton: UIButton = {
        let button = UIButton()
        button.setTitle("衛生写真", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    let mapNomalButton: UIButton = {
        let button = UIButton()
        button.setTitle("デフォルト", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
  
    func setupViews(){
        addSubview(mapSateliteButton)
        addSubview(mapNomalButton)
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        mapNomalButton.anchor(top: topAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight: 20)
        mapSateliteButton.anchor(top: mapNomalButton.bottomAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight:20,
                              bottom: bottomAnchor,paddingBottom: 10)
        
      
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

