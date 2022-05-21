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
        map.showsUserLocation = true
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
    
    var mapViewHeightConstraint: NSLayoutConstraint!
    var mapHeight = CGFloat()
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(backgraundImage)
        view.addSubview(profileImage)
        view.addSubview(postStackView)
        view.addSubview(friendStackView)
        view.addSubview(usernameLabel)
        view.addSubview(textLabel)
        view.addSubview(mapView)
        view.addSubview(editButton)
        mapView.addSubview(mapExpandButton)
        editButton.addTarget(self, action: #selector(sendEditPage(sender:)), for: .touchUpInside)
        mapExpandButton.addTarget(self, action: #selector(expand(sender:)), for: .touchUpInside)
        settingStackView()
        addConstraint()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("mapHeight",mapHeight)
        if mapHeight == 0.0{
            mapHeight = mapView.frame.minY - textLabel.frame.maxY + view.frame.width / 2 - 10
            mapViewHeightConstraint.constant =  mapHeight
            view.layoutIfNeeded()
        }
     
    }
    
    
    func  addConstraint(){
    
        backgraundImage.translatesAutoresizingMaskIntoConstraints = false
        backgraundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
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
        profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width / 2 - view.frame.width / 4 / 2).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        profileImage.layer.cornerRadius = view.frame.width / 4 / 2
        profileImage.clipsToBounds = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo:view.rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant:0).isActive = true
        textLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        textLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:0).isActive = true
        
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        postStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        postStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        postStackView.rightAnchor.constraint(equalTo: profileImage.leftAnchor, constant: -5).isActive = true

        friendStackView.translatesAutoresizingMaskIntoConstraints = false
        friendStackView.topAnchor.constraint(equalTo: backgraundImage.bottomAnchor, constant: 20).isActive = true
        friendStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        friendStackView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true

        
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:1).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -1).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        mapViewHeightConstraint = mapView.heightAnchor.constraint(equalToConstant: view.frame.width / 2)
        mapViewHeightConstraint.isActive = true

        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.systemGray3.cgColor
        
        mapExpandButton.translatesAutoresizingMaskIntoConstraints = false
        mapExpandButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 0).isActive = true
        mapExpandButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: 0).isActive = true
        mapExpandButton.widthAnchor.constraint(equalToConstant: view.frame.width / 12).isActive = true
        mapExpandButton.heightAnchor.constraint(equalToConstant: view.frame.width / 12).isActive = true
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
    @objc internal func expand(sender: UIButton) {
        isExpanded = !isExpanded
        if isExpanded{
            print("EXPANDED")
            
            let image = UIImage(systemName: "arrow.down.right.and.arrow.up.left.circle.fill")
            mapExpandButton.setBackgroundImage(image, for: .normal)
            
            let mapMinY = mapView.frame.minY
            let profileImageY = profileImage.frame.maxY
            print("--------------")
            print(mapMinY)
            print(profileImageY)
            UIView.animate(withDuration:0.5) { [self] in
                mapViewHeightConstraint.constant = mapMinY - profileImageY + mapHeight - 10
                view.layoutIfNeeded()
            }
          
        }
        else{
            print("No EXPANDED")
            let image = UIImage(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
            mapExpandButton.setBackgroundImage(image, for: .normal)
            UIView.animate(withDuration: 0.2) { [self] in
                
                mapViewHeightConstraint.constant = mapHeight
                
                view.layoutIfNeeded()
            }
           
          
           
        }
      }
    
    func getMyPost(){
        
    }
}


//"<NSLayoutConstraint:0x600003a8b9d0 MKMapView:0x7fc626077400.bottom == UILayoutGuide:0x600002093480'UIViewSafeAreaLayoutGuide'.bottom   (active)>",
//"<NSLayoutConstraint:0x600003a8b930 MKMapView:0x7fc626077400.height == 214   (active)>",
//"<NSLayoutConstraint:0x600003a919f0 MKMapView:0x7fc626077400.top == UILayoutGuide:0x600002093480'UIViewSafeAreaLayoutGuide'.top   (active)>",
//"<NSLayoutConstraint:0x600003a86030 'UIView-Encapsulated-Layout-Height' UIView:0x7fc623c4ba60.height == 926   (active)>",
//"<NSLayoutConstraint:0x600003a8fa70 'UIViewSafeAreaLayoutGuide-bottom' V:[UILayoutGuide:0x600002093480'UIViewSafeAreaLayoutGuide']-(83)-|   (active, names: '|':UIView:0x7fc623c4ba60 )>",
//"<NSLayoutConstraint:0x600003a8fb10 'UIViewSafeAreaLayoutGuide-top' V:|-(91)-[UILayoutGuide:0x600002093480'UIViewSafeAreaLayoutGuide']   (active, names: '|':UIView:0x7fc623c4ba60 )>"
