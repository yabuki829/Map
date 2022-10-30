//
//  ProfileViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//
import Foundation
import UIKit
import MapKit
import PKHUD
import AVFoundation

class profileViewController:UICollectionViewController{

    
    var isMyProfile = true
    var profile = Profile(userid: "error", username: "No Name", text: "PhotoEarth",
                          backgroundImage: ProfileImage(url: "background", name:"background"),
                          profileImage: ProfileImage(url: "person.crop.circle.fill", name: "person.crop.circle.fill"))
   
    var discriptionList = [Article]()
    var friendList = [Friend]()
    var menuCell:MenuCell?
    var mapAndDiscriptionCell:MapAndDiscriptionCell?
    
    var isReload = false
    override func viewDidLoad() {
        settingCollectionView()
        setNav()
        
        getDiscription()
        tabBarController?.tabBar.isHidden = false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        if isMyProfile {
            profile = DataManager.shere.getMyProfile()
            discriptionList = DataManager.shere.get()
            friendList = FollowManager.shere.getFollow()
            collectionView.reloadData()

        }
    }
    
    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        collectionView.register(MapAndDiscriptionCell.self, forCellWithReuseIdentifier: "MapAndDiscriptionCell")
        collectionView.backgroundColor = .white
    }
    
    func getDiscription(){
        //投稿を取得する
        //自分の投稿なのか　友達の投稿なのか
        discriptionList.removeAll()
        friendList.removeAll()
        if isMyProfile{
            //自分の投稿
         
            print("プロフィール取得する")
            profile = DataManager.shere.getMyProfile()
            discriptionList = DataManager.shere.get()
            friendList = FollowManager.shere.getFollow()
            collectionView.reloadData()
        }
        else{
            //友達の投稿
            print("------------友達の投稿です----------")
            HUD.show(.progress)
            FirebaseManager.shered.getDiscription(userid: profile.userid) { [weak self](discriptions) in
                FirebaseManager.shered.getFriendIdList(userid: (self?.profile.userid)!) { (followList) in
                    HUD.hide()
                   
                    self?.discriptionList = discriptions
                    self?.friendList = followList
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    func setNav(){
        self.title = "Profile"
        if isMyProfile {
            print("自分のProfile")
            let searchButton = UIImage(systemName: "magnifyingglass")
            let searchItem = UIBarButtonItem(image:searchButton, style: .plain, target: self, action: #selector(search(sender:)))
            searchItem.tintColor = .link
            navigationItem.leftBarButtonItem = searchItem
            
            searchItem.tintColor = .link
        }
        else{
            print("友達のプロフィール")
            let backButton = UIImage(systemName: "chevron.left")
            let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
            backItem.tintColor = .darkGray
            navigationItem.leftBarButtonItem = backItem
            
        
        }
      
    }
    
    @objc func search(sender : UIButton){
       print("search")
        let vc = FriendSearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func setting(sender : UIButton){
        print("Setting")
        let vc = EditViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func back(sender : UIButton){
        print("Back")
        self.navigationController?.popViewController(animated: true)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


extension profileViewController:UICollectionViewDelegateFlowLayout,reloadDelegate{

    
    func scroll() {
        collectionView.scrollToItem(at:IndexPath(row: 2, section: 0) , at: .centeredVertically, animated: true)
    }
    func reload() {
        if menuCell?.selectedIndexPath?.row == 0{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 0, section: 0) , at: .centeredHorizontally, animated: true)
        }
        else{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 1, section: 0) , at: .centeredHorizontally, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("アイウエオ")
        if indexPath.row == 0{
            // Profile
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            if isMyProfile{
                //myprofileに変更する
                cell.setCellA(profile:profile, followList: friendList, postList: discriptionList)
                cell.isMyprofile = isMyProfile
            }
            else{
                cell.setCellB(profile: profile, followList: friendList, postList: discriptionList)
                cell.isMyprofile = isMyProfile
            }
          
            cell.delegate = self
            return cell
        }
        else if indexPath.row == 1{
            // Menu
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.delegate = self
            menuCell = cell
            return cell
        }
        else {
            // CollectionView mapとcollectionview
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapAndDiscriptionCell", for: indexPath) as! MapAndDiscriptionCell
            cell.discriptioncell.delegate = self
            cell.mapCell.delegateWithMapCell = self
            
            cell.discriptionList = discriptionList
            cell.viewWidth = view.frame.width
            
            mapAndDiscriptionCell = cell
            mapAndDiscriptionCell?.mapCell.delegateWithMapCell = self
            mapAndDiscriptionCell?.mapCell.isProfile = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            // Profile
            return CGSize(width: view.frame.width, height: view.frame.width - 50)
        }
        else if indexPath.row == 1{
            // Menu
            return CGSize(width: view.frame.width, height: 30)
        }
        else {
            // CollectionView mapとcollectionview
            
            // view.frame.height から　navigationbar と　statusbar と　tabbar と　menubar の高さをひく
            let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 83
            let height = view.frame.height - statusBarHeight - navigationBarHeight - tabbarHeight
            
            return CGSize(width: view.frame.width, height:height - 30)
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension profileViewController {
    
}
extension profileViewController:transitionDelegate {
    func showMenu(disc: Article, profile: Profile) {}
    
    
    func toEditPageWithProfileCell() {
        let vc = EditViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
  
    //discriptionからの遷移
    func toDetailWithDiscriptionpCell(discription: Article) {
        let vc = detailViewController()
        vc.discription = discription
        
        vc.isProfile = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toDetailWithDiscriptionpCell(discription: Article,selectImage:UIImage) {
        let vc = detailViewController()
        vc.image = selectImage
        vc.discription = discription
        vc.isProfile = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toFriendList() {
        let vc = FriendListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension profileViewController:mapCellDelegate{
    func toDetailWithMapCell(discription: Article) {
        let vc = detailViewController()
        vc.discription = discription
        vc.isMapVC = false
        vc.isProfile = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Mapから遷移
    func toDetailWithMapCell(discription: Article, selectImage: UIImage) {
        let vc = detailViewController()
        vc.discription = discription
        vc.image = selectImage
        vc.isMapVC = false
        vc.isProfile = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
