//
//  FriendList.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/27.
//


import Foundation
import UIKit

class FriendListViewController:UIViewController{
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        return collecitonview
    }()
    var disc: Article?
    var profileList = [Profile]()
    var receiverList = [Friend]()
    var isBlockList = false
    var isPostView = false
    var isEditView = false
    override func viewDidLoad() {
        print("フレンド一覧")
        view.backgroundColor = .white
        view.addSubview(collectionView)
        addConstraint()
        setNav()
        settingCollectionView()
        getFriendProfile()
        if isBlockList {
            FollowManager.shere.userDefaults.removeObject(forKey: "block")
            title = "Blocked User"
        }
        if isPostView{
            title = "Friend List"
        }
        if isEditView {
            if LanguageManager.shered.getlocation() == ""{
                title = "投稿の公開範囲を変更"
            }
            else {
                title = "Publishing Settings"
            }
           
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    func getFriendProfile(){
        //インディケーター回す
        print("取得します")
        if isBlockList {
           
            let friendList = FollowManager.shere.getBlockedUser()
            print("ブロックした友達",friendList)
            FirebaseManager.shered.getBlockUserProfile(friendList: friendList) { (result) in
                //インディケーターを止める
                self.profileList = result
                self.collectionView.reloadData()
            }
        }
        else if isEditView{
            //profileとdiscのreciverを取得する
            let friend = FollowManager.shere.getFollow()
            print("友達",friend)
            
            FirebaseManager.shered.getReceiver(disc: disc!) { receiver in
                print("receiver",receiver)
                self.receiverList = FollowManager.shere.changeReciver(friendList: friend, reciver: receiver)
                print("receiverList",self.receiverList)
                FirebaseManager.shered.getFriendProfile(friendList: self.receiverList) { (result) in
                    print("取得完了")
                    //インディケーターを止める
                    self.profileList = result
                    self.collectionView.reloadData()
                }
            }
          
           
        }
        else{
            let friendList = FollowManager.shere.getFollow()
            FirebaseManager.shered.getFriendProfile(friendList: friendList ) { (result) in
                print("取得完了")
                //インディケーターを止める
                self.profileList = result
                self.collectionView.reloadData()
            }
        }
       
        
    }
    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FriendListCell.self, forCellWithReuseIdentifier: "FriendListCell")
        collectionView.register(FriendListWithPostCell.self, forCellWithReuseIdentifier: "FriendListWithPostCell")
        collectionView.backgroundColor = .white
    }
}

extension FriendListViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isBlockList || isEditView{
            print("blockUser cellefowekf@oewk]faoke]fok]awfapowf")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
            if isBlockList {
                cell.isBlockList = true
            }
            else {
                cell.isEditList = true
                cell.isReceiver = receiverList[indexPath.row].isSend
            }
            
            cell.setCell(imageurl: profileList[indexPath.row].profileImage.url,
                         username: profileList[indexPath.row].username,
                         text: profileList[indexPath.row].text,
                         userid: profileList[indexPath.row].userid)
            
            return cell
        }
        else if isPostView{
            print("投稿の公開範囲")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListWithPostCell", for: indexPath) as! FriendListWithPostCell
            
            cell.setCell(imageurl: profileList[indexPath.row].profileImage.url, username: profileList[indexPath.row].username, friend: FollowManager.shere.getFollow()[indexPath.row], index: indexPath.row)
            cell.backgroundColor = .systemGray6
            return cell
        }
        else{
            print("デフォルトのせる")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
            cell.isFriendList = true
            cell.setCell(imageurl: profileList[indexPath.row].profileImage.url, username: profileList[indexPath.row].username, text: profileList[indexPath.row].text, userid: profileList[indexPath.row].userid)
            
            return cell
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 12)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //遷移する
        if !isBlockList || !isEditView {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = .zero
            let vc = profileViewController(collectionViewLayout: layout)
            vc.profile = profileList[indexPath.row]
            vc.isMyProfile = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension FriendListViewController{
    func addConstraint(){
        collectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 0,
                              left: view.leftAnchor,paddingLeft: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 0)
    }
    
    func setNav(){
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.title = "Friend List"
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
    
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func back(sender : UIButton){
        print("Back")
        //ここでブロックの解除を決定する
        if isBlockList {
            var users = FollowManager.shere.getBlockedUser()
            let followList = FollowManager.shere.getBlockedUser()
            for i in 0..<followList.count {
                if !followList[i].isBlock {
                    for j in 0..<users.count {
                        if followList[i].userid == users[j].userid{
                            users.remove(at: j)
                            break
                        }
                    }
                    //フォローし直す
                        FollowManager.shere.follow(userid:followList[i].userid)
                }
            }
            print("block",users)
            FollowManager.shere.saveBlockList(blockList: users)
        }
        
        if isEditView {
            let receiver = DataManager.shere.getReceiver()
            print("公開範囲をこれに変更する",receiver)
            FirebaseManager.shered.editReceiver(postid: disc!.id, receiver:receiver )
            DataManager.shere.deleteReceiver()
        }
       
        self.navigationController?.popViewController(animated: true)
    }
}

