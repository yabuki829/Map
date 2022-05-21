//
//  EditViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/21.
//

import Foundation
import UIKit

class EditViewController : UIViewController{
    let backgraundImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "3")
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    let profileImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "profile")
        imageview.isUserInteractionEnabled = true
        
        return imageview
    }()
    
    let usernameStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    let textView:UITextView = {
        let textview = UITextView()
        textview.text = "藪木翔大は一体どんな存在なのかをきっちりわかるのが全ての問題の解くキーとなります。 この方面から考えるなら、一般的には、 藪木翔大を発生するには、一体どうやってできるのか；一方、藪木翔大を発生させない場合、何を通じてそれをできるのでしょうか。"
        return textview
    }()
    let textfield:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Name.."
        
        return textfield
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(backgraundImage)
        view.addSubview(profileImage)
        view.addSubview(usernameStackView)
        view.addSubview(textView)
        setNav()
        addConstraint()
        tapSetting()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textfield.setUnderLine(color: .black)
    }

    func setNav(){
        self.title = "Edit"
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        
        let editItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action:  #selector(edit(sender:)))
    
        backItem.tintColor = .darkGray
        editItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
        
        navigationItem.rightBarButtonItem = editItem
    }
    func  addConstraint(){
    
        backgraundImage.translatesAutoresizingMaskIntoConstraints = false
        backgraundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backgraundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgraundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgraundImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2  ).isActive = true
        backgraundImage.widthAnchor.constraint(equalToConstant: view.frame.width  ).isActive = true

        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: -view.frame.width / 4 / 2 ).isActive = true
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 2 - view.frame.width / 4 / 2).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.layer.cornerRadius = view.frame.width / 4 / 2
        profileImage.clipsToBounds = true
        
        usernameStackView.translatesAutoresizingMaskIntoConstraints = false
        usernameStackView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        usernameStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        usernameStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
       
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: usernameStackView.bottomAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
      
        
        let label = UILabel()
        label.text = "NAME:"
       
        usernameStackView.addArrangedSubview(label)
        usernameStackView.addArrangedSubview(textfield)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    func tapSetting(){
        let tapprofileimage = UITapGestureRecognizer(target: self, action: #selector(tapProfileImage(sender:)))
        let tapbackgroundimage = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundImage(sender:)))
        profileImage.addGestureRecognizer(tapprofileimage)
        backgraundImage.addGestureRecognizer(tapbackgroundimage)
    }
    @objc func back(sender : UIButton){
        print("Back")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func edit(sender : UIButton){
        print("Edit")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func tapProfileImage(sender:UITapGestureRecognizer){
        print("Tap Profile Image")
        //画像を開き正方形でカットする
    }
    @objc func tapBackgroundImage(sender:UITapGestureRecognizer){
        print("Tap Backgraund Image")
        //画像を開き長方形でカットする
    }
}
