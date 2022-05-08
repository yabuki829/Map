//
//  PostView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/09.
//

import Foundation
import UIKit

class PostViewController:UIViewController,UITextViewDelegate{
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var placeholderLabel : UILabel!
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        cv.backgroundColor = .red
        return cv
    }()
    
    let locationButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("位置情報を追加する", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray2, for:.highlighted )
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "投稿画面"
        self.view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(collectionView)
        view.addSubview(locationButton)
        addConstraintTextView()
        addConstraintCollectionView()
        
        setupNavigationItems()
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        textView.becomeFirstResponder()
        textView.delegate = self
        settingTextViewPlaceHolder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(
                   self,
                   selector:#selector(keyboardWillShow(_:)),
                   name: UIResponder.keyboardWillShowNotification,
                   object: nil
                 )
    }
    func setupNavigationItems(){
        navigationController?.navigationBar.shadowImage = UIImage()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
       
        let backItem  = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(back))
        let postItem = UIBarButtonItem(title: "投稿する", style: .plain, target: self, action: #selector(post))
        backItem.tintColor = .link
        postItem.tintColor = .link
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = postItem
        
    }
    @objc  func post(){
       print("投稿する")
        //投稿する
     }
     @objc func back(){
         print("前の画面に戻る")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
     }
    func addConstraintTextView(){
        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    func addConstraintCollectionView(){
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        

        locationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
         
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
          
          UIView.animate(withDuration: 1.5, animations: { [self] () -> Void in
            collectionView.isHidden = false
            
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardFrame.size.height).isActive = true
            locationButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant:  0).isActive = true
            collectionView.layoutIfNeeded()
            locationButton.layoutIfNeeded()
          })
          
       }
    
    func settingTextViewPlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "出来事を記録しましょう"
      
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 15, y: 20)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    func textViewDidChange(_ textView: UITextView) {
        print("変更しました")
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
