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
     
        menuItem(name: "アカウントについて", icon: "pencil"),
            menuItem(name: "ブロックしたアカウント一覧", icon: "questionmark.circle"),
//            menuItem(name: "サブスクリプションについて", icon: "questionmark.circle"),
            menuItem(name: "サインアウト", icon: "rectangle.portrait.and.arrow.right"),
            menuItem(name: "アカウントの削除", icon: "trash"),
        menuItem(name: "その他", icon: ""),
            menuItem(name: "お問い合わせ", icon: "phone.circle"),
//            menuItem(name: "レビューを書く", icon: "pencil"),
        menuItem(name: "開発者のその他アプリ", icon: "pencil"),
            menuItem(name: "TasksTodo", icon: "doc"),
    ]
       
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
        return true
    }
       override func viewDidLoad() {
           print("settingviewcontroller")
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
        self.navigationController?.popViewController(animated: true)
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
        if indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 6{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section", for: indexPath) as! SectionCell
            cell.setCell(title:settingdata[indexPath.row].name )
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
        print(indexPath.row,settingdata[indexPath.row].name)
        if indexPath.row == 1{
            //twitterを開く
           
            
            let vc = FriendListViewController()
            vc.isBlockList = true
            navigationController?.pushViewController(vc, animated: true)
        }
//        else if indexPath.row == 2{
//            let nav = UINavigationController(rootViewController: SubscriptionViewController())
//            self.present(nav, animated: true, completion: nil)
//        }
        else if indexPath.row == 2{
            
            signoutAlert()
          
        }
        else if indexPath.row == 3{
            deleteAccountAlert()
            
           
        }
      
        else if indexPath.row == 4{
            let url = URL(string: "https://mobile.twitter.com/sdi2025")
            UIApplication.shared.open(url!)
           
        }
//        else if indexPath.row == 5{
//            //　レビューを書く
//        }
        else if indexPath.row == 5{
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
    
    func signoutAlert(){
        let alert = UIAlertController(title: "サインアウト", message: "サインアウトしますか？", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "サインアト", style: .default, handler: { _ in
           //削除して前の画面に戻る
            AuthManager.shered.logout { result in
                if result{
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                
                }
            }
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    func deleteAccountAlert(){
        let alert = UIAlertController(title: "削除", message: "アカウントを削除しますか？", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { _ in
           //削除して前の画面に戻る
            AuthManager.shered.deleteAccount { result in
                if result {
                    //login pageに遷移する
                    let vc = LoginViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
}


