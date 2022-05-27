//
//  ProfileViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit
import MapKit

class ProfileViewController:UIViewController{
    var profile: Profile?{
        didSet{
            setupImage()
            usernameLabel.text = profile?.username
            textLabel.text = profile?.text
        }
    }
    
    let backgraundImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "3")
        
        return imageview
    }()
    let profileImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "profile")
        imageview.backgroundColor = .white
        return imageview
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.text = "Yabuki Shodai"
        return label
    }()
    
    let textLabel:UILabel = {
        let label = UILabel()
        label.text = "Learn from the mistakes of others. You can’t live long enough to make them all yourself."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .satellite
        return map
    }()
    
    let postStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        return stackView
    }()
    let friendStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    let editButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .link
        
        return button
    }()
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collecitonview = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collecitonview.isScrollEnabled = false
        return collecitonview
    }()
    var messageItem = UIBarButtonItem()
    let menuBar = MenuBar()
    let scrollview = UIScrollView()
    var mapViewHeightConstraint: NSLayoutConstraint!
    var scrollViewBottomConstraint:  NSLayoutConstraint!
    var cvHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(scrollview)
        scrollview.addSubview(backgraundImage)
        scrollview.addSubview(profileImage)
        scrollview.addSubview(postStackView)
        scrollview.addSubview(friendStackView)
        scrollview.addSubview(usernameLabel)
        scrollview.addSubview(textLabel)
        scrollview.addSubview(editButton)
        scrollview.addSubview(menuBar)
        scrollview.addSubview(collectionView)
        aaa()
    
        if profile?.userid == nil{
            profile = DataManager.shere.getProfile()
        }
        setNav()
        editButton.addTarget(self, action: #selector(sendEditPage(sender:)), for: .touchUpInside)
        
        let tapFriend = UITapGestureRecognizer(target: self, action: #selector(tapFriendList(sender:)))
        friendStackView.addGestureRecognizer(tapFriend)
        
        let tapPost = UITapGestureRecognizer(target: self, action: #selector(tapPost(sender:)))
        postStackView.addGestureRecognizer(tapPost)
        
        settingStackView()
        settingCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        if menuBar.selectedIndexPath?.row == 0{
            let menubarMaxY = menuBar.frame.maxY
            scrollview.contentSize = CGSize(width: view.frame.width, height: menubarMaxY + view.frame.width + 10)
        }
      
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
   
    func setupImage(){
        
        if let imageurl = profile?.profileImage?.imageUrl{
            
            let urlDefault = "defaultsPRO"
            print("A:",imageurl)
            if urlDefault == imageurl{
                print("こっちA")
                profileImage.image = UIImage(named: "profile")
            }
            else{
                print("こっちa")
                profileImage.loadImageUsingUrlString(urlString: imageurl)
            }
           
        }
        
        if let imageurl = profile?.backgroundImage?.imageUrl{
            let urlDefault = "defaultsBG"
            print("B:",imageurl)
            
            if urlDefault == imageurl || imageurl == ""  {
                print("こっちB")
                backgraundImage.image = UIImage(named: "background")
            }
            else{
                print("こっちb")
                backgraundImage.loadImageUsingUrlString(urlString: imageurl)
            }
           
        }
    }
    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        collectionView.backgroundColor = .white
        menuBar.delegate = self
    }
    
    func aaa(){
        scrollview.flashScrollIndicators()
        scrollview.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollview.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant:0).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        backgraundImage.translatesAutoresizingMaskIntoConstraints = false
        backgraundImage.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 0).isActive = true
        backgraundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgraundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgraundImage.heightAnchor.constraint(equalToConstant: view.frame.width / 2  ).isActive = true
        backgraundImage.widthAnchor.constraint(equalToConstant: view.frame.width  ).isActive = true
    

        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.topAnchor.constraint(equalTo: backgraundImage.topAnchor, constant: 5).isActive = true
        editButton.rightAnchor.constraint(equalTo: backgraundImage.rightAnchor, constant: -5).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: view.frame.width / 12).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: view.frame.width / 12).isActive = true
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: -view.frame.width / 4 / 2 ).isActive = true
        profileImage.leftAnchor.constraint(equalTo: scrollview.leftAnchor, constant: view.frame.width / 2 - view.frame.width / 4 / 2).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.layer.cornerRadius = view.frame.width / 4 / 2
        profileImage.clipsToBounds = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo:scrollview.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant:0).isActive = true
        textLabel.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        textLabel.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: menuBar.topAnchor, constant: 0).isActive = true
        
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0).isActive = true
        menuBar.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        menuBar.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        postStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        postStackView.rightAnchor.constraint(equalTo: profileImage.leftAnchor, constant: -20).isActive = true
        postStackView.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        
        friendStackView.translatesAutoresizingMaskIntoConstraints = false
        friendStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        friendStackView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        friendStackView.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true  
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant:0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }

    func settingStackView(){
        let titleLabel = UILabel()
            titleLabel.text = String(DataManager.shere.get().count)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            titleLabel.textAlignment = .center
            titleLabel.textColor = .link
        
        
        let subTitleLabel = UILabel()
            subTitleLabel.text = "Posts"
            subTitleLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            subTitleLabel.textAlignment = .center
            subTitleLabel.textColor = .lightGray
        
        postStackView.addArrangedSubview(titleLabel)
        postStackView.addArrangedSubview(subTitleLabel)

        
        let titleLabel2 = UILabel()
            titleLabel2.text = String(DataManager.shere.getFollow().count)
            titleLabel2.font = UIFont.boldSystemFont(ofSize: 16.0)
            titleLabel2.textAlignment = .center
            titleLabel2.textColor = .link
        
        
        let subTitleLabel2 = UILabel()
            subTitleLabel2.text = "Friends"
            subTitleLabel2.font = UIFont.boldSystemFont(ofSize: 12.0)
            subTitleLabel2.textAlignment = .center
            subTitleLabel2.textColor = .lightGray
        
        friendStackView.addArrangedSubview(titleLabel2)
        friendStackView.addArrangedSubview(subTitleLabel2)
        
    }
    @objc internal func sendEditPage(sender: UIButton) {
        print("Edit")
        let vc = EditViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .flipHorizontal
        self.present(nav, animated: true, completion: nil)
    }
    func isMyProfile() -> Bool{
        //自分のprofile画面かどうか
        print("profile",profile?.userid)
        if profile?.userid == FirebaseManager.shered.getMyUserid() || profile?.userid == ""{
            return true
        }
        return false
    }
    
    
    func setNav(){
        self.title = "Profile"
        if isMyProfile() {
            print("自分のProfile")
            let searchButton = UIImage(systemName: "magnifyingglass")
            let searchItem = UIBarButtonItem(image:searchButton, style: .plain, target: self, action: #selector(search(sender:)))
            searchItem.tintColor = .link
            navigationItem.leftBarButtonItem = searchItem
            
            messageItem = UIBarButtonItem(title: "Message", style: .plain, target: self, action:#selector(message(sender:)) )
            messageItem.tintColor = .link
            navigationItem.rightBarButtonItem = messageItem
            
            friendStackView.isUserInteractionEnabled = true
            editButton.isHidden = false
            editButton.isEnabled = true
        }
        else{
            print("友達のプロフィール")
            let backButton = UIImage(systemName: "chevron.left")
            let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
            backItem.tintColor = .darkGray
            navigationItem.leftBarButtonItem = backItem
            
            friendStackView.isUserInteractionEnabled = false
            
            editButton.isHidden = true
            editButton.isEnabled = false
        }
        
        
      
    }
    @objc func back(sender : UIButton){
        print("Back")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc internal func tapFriendList(sender:UITapGestureRecognizer ){
        print("友達一覧に遷移する")
        let  vc = FriendListViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @objc internal func tapPost(sender:UITapGestureRecognizer ){
        print("投稿一覧")
//        menuBar.selectedIndexPath = IndexPath(row: 1, section: 0)
//        collectionView.selectItem(at:menuBar.selectedIndexPath , animated: true, scrollPosition: .left)
    }
 
    @objc func message(sender : UIButton){
        print("Message")
    }
    @objc func search(sender : UIButton){
       print("search")
        let vc = FriendSearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }
}

extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,reloadDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            //マップを表示する　MapCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.backgroundColor = .link
            return cell
        }
        else{
            //今までの投稿一覧を表示する DiscriptionCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .orange
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            return CGSize(width: view.frame.width, height: view.frame.width)
        }
        else{
            return CGSize(width: view.frame.width, height:view.frame.height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func reload() {
        print("リロード")
        if menuBar.selectedIndexPath?.row == 0{
            //map
          
            self.collectionView.selectItem(at:menuBar.selectedIndexPath , animated: true, scrollPosition: .left)
            let menubarMaxY = menuBar.frame.maxY
            scrollview.contentSize = CGSize(width: view.frame.width, height: menubarMaxY + view.frame.width + 10)
         
            
        }
        else{
            //description
            let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController!.tabBar.frame.size.height
           
            self.collectionView.selectItem(at:menuBar.selectedIndexPath , animated: true, scrollPosition: .left)
            let defalutHeight = view.frame.height - statusBarHeight - tabbarHeight - navigationBarHeight
            scrollview.contentSize.height = defalutHeight  + menuBar.frame.minY + 5
            
        }
    }
}


class MapCell: BaseCell{
    let mapView: MKMapView = {
        let map = MKMapView()
//        map.mapType = .satelliteFlyover
        return map
    }()
    override func setupViews() {
        addSubview(mapView)
        addConstraint()
    }
    func addConstraint(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.topAnchor, constant:0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
