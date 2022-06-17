//
//  SettingViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/12.
//

import Foundation
import UIKit

struct menuItem{
    let name:String
    let icon:String
}


class SettingViewController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    let BackBottomButton:UIButton = {
        let button = UIButton()
        return button
    }()
    let BackButton:UIButton = {
        let button = UIButton()
        return button
    }()
    let settingdata = [
        menuItem(name: "お問い合わせ", icon: "mail"),
        menuItem(name: "レビューを書く", icon: "pencil"),
        menuItem(name: "サインアウト", icon: "rectangle.portrait.and.arrow.right"),
        menuItem(name: "アカウントの削除", icon: "trash"),
        menuItem(name: "comming soon", icon: "questionmark.circle"),
        menuItem(name: "開発者のその他アプリ", icon: "pencil"),
        menuItem(name: "TasksTodo", icon: "doc"),
    ]
       
    
       override func viewDidLoad() {
           
            let accountImage = UIImage(systemName: "multiply")
            let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(onClickMyButton(sender:)))
            accountItem.tintColor = .darkGray
            navigationItem.leftBarButtonItem = accountItem
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
            collectionView.register(menubarCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.register(SectionCell.self, forCellWithReuseIdentifier: "section")
            view.addSubview(collectionView)
            addCollectionViewConstraint()
       }
       @objc func onClickMyButton(sender : UIButton){

           self.navigationController?.dismiss(animated: true, completion: nil)
       }
       
       
    
    func addCollectionViewConstraint(){
           collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
           collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
           collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
           collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
       
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return settingdata.count
    }
       
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        if indexPath.row == 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section", for: indexPath) as! SectionCell
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! menubarCell
            cell.setCell(setting: settingdata[indexPath.row])
            return cell
        }
           
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width:collectionView.frame.width, height:40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 0
    }
  
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(settingdata[indexPath.row].name)
        if indexPath.row == 0{
            //twitterを開く
            let url = URL(string: "https://mobile.twitter.com/sdi2025")
            UIApplication.shared.open(url!)
        }
        else if indexPath.row == 1{
            //レビューを書く
        }
        else if indexPath.row == 2{
            //sign out ここから
//            AuthManager.shered.loginOut()
            //useridを削除する
            //login pageに遷移する
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 3{
            //アカウント削除　ここから
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            AuthManager.shered.deleteAccount { result in
                if result {
                    //login pageに遷移する
                   
                }
            }
        }
        
        else if indexPath.row == 5{
            //瞬間日記開く
            openApp("id1592943322")
        }
    }
       
    
    func openApp(_ id: String){
        let url = URL(string: "https://itunes.apple.com/jp/app/apple-store/\(id)")!

           if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:]) { success in
                   if success {
                       print("Launching \(url) was successful")
                   }
               }
           }
    }
}


