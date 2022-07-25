//
//  FriendListView.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/25.
//

import Foundation
import UIKit



class FriendListView:UIView{
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        return collecitonview
    }()
    
    var friendList :[Friend]?{
        didSet{
            getProfile()
        }
    }
    
    var profileList = [Profile]()
    var height = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        settingCollectionView()
    }
    
    func setupViews(){
        print("setupviews")
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, paddingTop: 0,
                              left: leftAnchor, paddingLeft: 0,
                              right: rightAnchor, paddingRight: 0,
                              bottom: bottomAnchor, paddingBottom:0 )
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FriendListWithPostCell.self, forCellWithReuseIdentifier: "FriendListWithPostCell")
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    func getProfile(){
        print("profile取得")
        FirebaseManager.shered.getFriendProfile(friendList: friendList!) { [self] result in
            print("完了")
            profileList = result
            collectionView.reloadData()
        }
    }
}


extension FriendListView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("height",height)
        return CGSize(width: frame.width, height: height / 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendListWithPostCell", for: indexPath) as! FriendListWithPostCell
        //        isSend -> FriendList[indexPath.row].isSend
        cell.setCell(imageurl: profileList[indexPath.row].profileImage.url, username: profileList[indexPath.row].username, friend: friendList![indexPath.row], index: indexPath.row)
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    
}


