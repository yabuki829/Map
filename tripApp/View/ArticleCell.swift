//
//  ArticleCell.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/27.
//

import Foundation
import UIKit



class ArticleCell:UICollectionViewCell{
    weak var delegate:ArticleCellDelegate? = nil
    var discription: Article?
    //profile画像　username
    var profile:Profile?
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let menuButton:UIButton = {
        let button = UIButton()
            button.setImage(UIImage(systemName: "ellipsis" ), for: .normal)
        return button
    }()
    
    let videoView = VideoPlayer()
    let username:UILabel = {
        let label = UILabel()
        return label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    let playimage:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "play.fill")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){}
    func addConstraint(){
        self.addSubview(profileImageView)
        self.addSubview(username)
        self.addSubview(dateLabel)
        self.addSubview(menuButton)
        self.addSubview(imageView)
        imageView.anchor(top: username.bottomAnchor, paddingTop: 10,
                             left: profileImageView.rightAnchor, paddingLeft: 0,
                             right: self.rightAnchor, paddingRight: 10,
                             bottom: self.bottomAnchor, paddingBottom: 0,
                             width: self.frame.width - 70, height: self.frame.width - 70)
      
      
        
        profileImageView.anchor(top: self.topAnchor, paddingTop: 10,
                                left: self.leftAnchor, paddingLeft: 10,
                                width: 50, height: 50)
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        
        username.anchor(top: self.topAnchor, paddingTop: 10,
                        left: profileImageView.rightAnchor, paddingLeft: 5)
        
        menuButton.anchor(top:self.topAnchor ,paddingTop: 5,
                          left: username.rightAnchor,paddingLeft: 5,
                          right: self.rightAnchor,paddingRight: 10,
                          width: 20,height: 20)
        
        dateLabel.anchor(right: self.rightAnchor, paddingRight: 10,
                         bottom: imageView.topAnchor,paddingBottom:5    )
        
        menuButton.addTarget(self, action: #selector(showMenbar(sender:)), for: .touchDown)
        
    }
    @objc internal func showMenbar(sender: UIButton) {
        print("show Menu bar")
        delegate?.showMenu(disc: discription!,profile:profile!)
    
            
    }
    func setCell(disc:Article){
        discription = disc
        getProfile(userid: disc.userid)
        
        if disc.type == "image" {
            playimage.isHidden = true
            imageView.image = UIImage()
            imageView.setImage(urlString: disc.data.url)
        }
        else{
            playimage.isHidden = false
            imageView.image = UIImage()
            imageView.setImage(urlString: disc.thumnail!.url)
            imageView.addSubview(playimage)
            playimage.center(inView: imageView)
         
        }
        dateLabel.text = disc.created.secondAgo()
        addConstraint()
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getProfile(userid:String){
        FirebaseManager.shered.getProfile(userid: userid) { result in
            self.profile = result
            if result.profileImage.url == "person.crop.circle.fill" || result.profileImage.name == "person.crop.circle.fill"{
                self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
                self.profileImageView.backgroundColor = .white
                
            }
            else {
                self.profileImageView.setImage(urlString: result.profileImage.url)
            }
           
            self.username.text = result.username
        }
    }
    
}





class DetailMenuBar:baseView ,UITableViewDelegate,UITableViewDataSource{
   
  
    
    let tableview  = UITableView()
    var menuTitleArray  = [Menu]()
    override func setupViews() {
        addSubview(tableview)
        tableview.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                         left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                         right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                         bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(DetailMenuBarCell.self, forCellReuseIdentifier: "cell")
       
    }
    func setData(array:[Menu]){
        print(array)
        menuTitleArray = array
        tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailMenuBarCell
        cell.setCell(menu: menuTitleArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
   
}

protocol ArticleCellDelegate :AnyObject{
    func showMenu(disc:Article,profile:Profile)
}

struct Menu {
    let title:String
    let image:String
}


class DetailMenuBarCell :BaseTableViewCell {
    let titleLabel = UILabel()
    let imageview  = UIImageView()
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(imageview)
        titleLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 5,
                          left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 5,
                          right: imageview.rightAnchor, paddingRight: 5,
                          bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 5)
        imageview.anchor(left: titleLabel.rightAnchor, paddingLeft: 5,
                         right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 5,
                        width: 20, height: 20)
        imageview.centerY(inView: self)
    }
    
    func setCell(menu:Menu){
        print("呼ばれてます",menu.title)
        titleLabel.text = menu.title
        imageview.image = UIImage(systemName: menu.image)
    }
}
