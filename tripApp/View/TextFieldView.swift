//
//  TextFieldView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

class textFieldView:UIView{
    
    var textfield:UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .systemGray6
        textfield.layer.cornerRadius = 16
        textfield.layer.borderWidth = 2.0
        textfield.layer.borderColor = UIColor.systemGray2.cgColor
        textfield.clipsToBounds = true
        return textfield
    }()
    
    var sendButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("送信", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    var messageID = String()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(messageid:String){
        print("B")
        messageID = messageid
        self.addSubview(textfield)
        self.addSubview(sendButton)
        addConsrtaints()
    }
    
    @objc func sendComment(){
        if textfield.text == ""{
            return
        }
        //postID
        FirebaseManager.shered.sendComment(text: textfield.text!, messageid: messageID)
        textfield.text = ""
    }
    func addConsrtaints(){
        textfield.topAnchor.constraint(equalTo: self.topAnchor, constant: 2.0).isActive = true
        textfield.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        textfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 0.0).isActive = true
        textfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2.0).isActive = true
        
        sendButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5.0).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60 ).isActive = true
        print(self.frame.width)
    }
 
}


