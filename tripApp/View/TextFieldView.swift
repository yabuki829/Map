//
//  TextFieldView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

class textFieldView:UIView,UITextFieldDelegate{
    
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
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .link
        return button
    }()
    var postID = String()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        textfield.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(postid:String){
        postID = postid
        
        addSubview(textfield)
        addSubview(sendButton)
    
        addConsrtaints()
    }
    
    @objc func sendComment(){
        if textfield.text == ""{
            return
        }
        
        //postID
        FirebaseManager.shered.sendComment(text: textfield.text!, messageid: postID)
        textfield.text = ""
        delegate?.completealert()
    }
    
    func addConsrtaints(){
        
        textfield.anchor(top: topAnchor, paddingTop: 2.0,
                         left:leftAnchor, paddingLeft: 10.0,
                         right: sendButton.leftAnchor, paddingRight: 0.0,
                         bottom: bottomAnchor, paddingBottom: 2.0)
        
        sendButton.anchor(top: topAnchor, paddingTop: 2.0,
                          right: rightAnchor, paddingRight: 5.0,
                          bottom:bottomAnchor, paddingBottom: 0.0,
                          width: 60)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
         print("変更されました")
    }
    weak var delegate:CommentDelegate? = nil
}


protocol CommentDelegate: AnyObject  {
    func completealert()
}
