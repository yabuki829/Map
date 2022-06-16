//
//  NewChatViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/06/07.
//

import Foundation

import UIKit

class NewChatViewController:UIViewController{
    public var compleation:((Profile) -> (Void))?
    let searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        return collecitonview
    }()
    var profileList = [Profile]()
    
    override func viewDidLoad() {
      
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        addConstraint()
        setNav()
        settingCollectionView()
        getFriendProfile()
    }

    func getFriendProfile(){
        //インディケーター回す
        print("取得します")
        let friendList = DataManager.shere.getFollow()
        print(friendList)
        FirebaseManager.shered.getFriendProfile(friendList: friendList ) { (result) in
            print("取得完了")
            //インディケーターを止める
            self.profileList = result
            self.collectionView.reloadData()
        }
    }
    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FriendListCell.self, forCellWithReuseIdentifier: "FriendListCell")
        collectionView.backgroundColor = .white
    }
}

extension NewChatViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        cell.setCell(imageurl: (profileList[indexPath.row].profileImageUrl), username: profileList[indexPath.row].username, text: profileList[indexPath.row].text!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 12)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("chatの画面に遷移する")
        let selectprofile = profileList[indexPath.row]
       
        dismiss(animated: true) { [weak self] in
            self?.compleation?(selectprofile)
        }
    }
    
}


extension NewChatViewController{
    func addConstraint(){
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0)
        collectionView.anchor(top:searchBar.bottomAnchor,paddingTop: 0,
                              left: view.leftAnchor,paddingLeft: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 0)
    }
    
    func setNav(){
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.title = "Friend List"
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back))
    
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func back(){
        print("Back")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

