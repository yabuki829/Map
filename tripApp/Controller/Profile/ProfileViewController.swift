//
//  ProfileViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit
import MapKit

//https://images.app.goo.gl/85uSkPvJTkX3FFf38  edit　画面
class ProfileViewController:UIViewController{
    var profile: Profile?{
        didSet{
            setupImage()
            usernameLabel.text = profile?.username
//            textLabel.text = profile?.text
        }
    }
    let mapExpandButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .link
        return button
    }()
    
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
        label.text = "藪木翔大は一体どんな存在なのかをきっちりわかるのが全ての問題の解くキーとなります。 この方面から考えるなら、一般的には、 藪木翔大を発生するには、一体どうやってできるのか；一方、藪木翔大を発生させない場合、何を通じてそれをできるのでしょうか。"
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
  
        editButton.addTarget(self, action: #selector(sendEditPage(sender:)), for: .touchUpInside)
        
        settingStackView()
        settingCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        if menuBar.selectedIndexPath?.row == 0{
           
            let menubarMaxY = menuBar.frame.maxY 
            scrollview.contentSize = CGSize(width: view.frame.width, height: menubarMaxY + view.frame.width )
         
            
        }
      
    }
    override func viewWillAppear(_ animated: Bool) {
        profile = DataManager.shere.getProfile()
        
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
            
            if urlDefault == imageurl {
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
//        menuBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        postStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        postStackView.rightAnchor.constraint(equalTo: profileImage.leftAnchor, constant: -20).isActive = true
        postStackView.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true

        friendStackView.translatesAutoresizingMaskIntoConstraints = false
        friendStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        friendStackView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        friendStackView.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant: 20).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.rightAnchor, constant:0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: scrollview.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }

    func settingStackView(){
        let titleLabel = UILabel()
            titleLabel.text = "19"
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
            titleLabel2.text = "10"
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
            scrollview.contentSize = CGSize(width: view.frame.width, height: menubarMaxY + view.frame.width )
         
            
        }
        else{
            //description
            let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController!.tabBar.frame.size.height
           
            self.collectionView.selectItem(at:menuBar.selectedIndexPath , animated: true, scrollPosition: .left)
            let defalutHeight = view.frame.height - statusBarHeight - tabbarHeight - navigationBarHeight
            scrollview.contentSize.height = defalutHeight  + menuBar.frame.minY + 5
            print("コレクション",collectionView.frame.height, scrollview.frame.height)
            
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
