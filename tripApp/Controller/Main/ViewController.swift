
import UIKit
import MapKit
import CoreLocation
import Photos
import PKHUD


class MapViewController: UIViewController, reloadDelegate {
 

    
    var postButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
      
        cv.backgroundColor = .systemGray6
        return cv
    }()
    var menuCell:MenuCell?
    var mapCell:MapCell?
    var mapAndDiscriptionCell:MapAndDiscriptionCell?
    let refresher = UIRefreshControl()
    var locationManager:CLLocationManager!
    var discriptipns = [Discription]()
    var selectDiary:Discription?
    var selectImage = UIImage()
    var isReload = false

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        print("縦画面")
        return .portrait
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white

        view.addSubview(collectionView)
        view.addSubview(postButton)

        addConstraint()
        postButton.addTarget(self, action: #selector(sendtoPostView(sender:)), for: .touchUpInside)


        setupNavigationItems()
        settingCollectionView()
        getDiscription()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        
        if isReload {
            print("getdiscription")

            
            getDiscription()
            isReload = false
        }
        
    }
    
    @objc internal func sendtoPostView(sender: UIButton) {
        if DataManager.shere.get().count < 100 {
            let vc = PostViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let alert = AlertManager.shared.shewMessage(title: "15件までしか投稿できません", message: "投稿を削除してしてください")
            present(alert, animated: true)
        }
      }

    @objc func tapSettingIcon(){
        
      print("setting")
        let layout = UICollectionViewFlowLayout()
        let vc = SettingViewController(collectionViewLayout: layout)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
     }
    @objc func refresh(){
        print("Refreshh")
        getDiscription()
     }
    func getDiscription(){
      //自分の投稿と友達の投稿あとprofileを取得する
        discriptipns = []
        
        FirebaseManager.shered.getFriendDiscription { [self] result in
            refresher.endRefreshing()
            discriptipns.append(contentsOf: result)
            collectionView.reloadData()
        }
    
    }

}


extension MapViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   

    
    
  
    
    func reload() {
        if menuCell?.selectedIndexPath?.row == 0{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 0, section: 0) , at: .centeredHorizontally, animated: true)
        }
        else{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 1, section: 0) , at: .centeredHorizontally, animated: true)
        }
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.row == 0{
            // Profile

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.delegate = self
            cell.menuBarTitleArray = ["house","map"]
            menuCell = cell
            return cell
        }
        else{
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapAndDiscriptionCell", for: indexPath) as! MapAndDiscriptionCell
            cell.discriptioncell.delegate = self
            cell.mapCell.delegateWithMapCell = self
            cell.discriptioncell.isHome = true
            cell.discriptionList = discriptipns
            cell.viewWidth = view.frame.width
            
            mapAndDiscriptionCell = cell
            mapAndDiscriptionCell?.mapCell.delegateWithMapCell = self
            
            return cell
            
        }
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0{
            // Profile
            return CGSize(width: view.frame.width, height: 30)
        }
        else {
            // view.frame.height から　navigationbar と　statusbar と　tabbar と　menubar の高さをひく
            let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
            let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 83
            let height = view.frame.height - statusBarHeight - navigationBarHeight - tabbarHeight
            print("height",height)
            return CGSize(width: view.frame.width, height:height  - 25) //25でなく30にするとリフレッシュがしにくい
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}


extension MapViewController {
    func addConstraint(){
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:-20).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                              left: view.leftAnchor, paddingLeft: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0
                          )
    }


    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        collectionView.register(MapAndDiscriptionCell.self, forCellWithReuseIdentifier: "MapAndDiscriptionCell")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refresher)
        
    }


    func setupNavigationItems(){
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.font = UIFont(name: "Times New Roman", size: 20)
        titleLabel.text = "PhotoShare"
        titleLabel.tintColor = .darkGray
        navigationItem.titleView = titleLabel
        let accountImage = UIImage(systemName: "text.justify")
        let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(tapSettingIcon))
        
        navigationItem.rightBarButtonItems = [accountItem]
        navigationController?.navigationBar.tintColor = .darkGray
    }
}



class articleCell:UICollectionViewCell{
    var discription: Discription?
    //profile画像　username
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
       
    }
    func addConstraint(){
        self.addSubview(profileImageView)
        self.addSubview(username)
        self.addSubview(dateLabel)
        
        
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
                        
        dateLabel.anchor(top: self.topAnchor, paddingTop: 10,
                        left: username.rightAnchor, paddingLeft: 5,
                        right: self.rightAnchor, paddingRight: 5)
        
       
        
    }
    func setCell(disc:Discription){
        discription = disc
        getProfile(userid: disc.userid)
        
        if disc.type == "image" {
            imageView.image = UIImage()
            imageView.setImage(urlString: disc.data.url)
        }
        else{
            imageView.image = UIImage()
            imageView.setImage(urlString: disc.thumnail!.url)
            
            let playimage = UIImageView()
            playimage.image = UIImage(systemName: "play.fill")
            playimage.tintColor = .white
            imageView.addSubview(playimage)
            playimage.center(inView: imageView)
        }
       
        addConstraint()
       
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getProfile(userid:String){
        FirebaseManager.shered.getProfile(userid: userid) { result in
            self.profileImageView.setImage(urlString: result.profileImageUrl)
            self.username.text = result.username
        }
    }
}




class MenuView:UIView{
    let mapSateliteButton: UIButton = {
        let button = UIButton()
        button.setTitle("衛生写真", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    let mapNomalButton: UIButton = {
        let button = UIButton()
        button.setTitle("デフォルト", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
  
    func setupViews(){
        addSubview(mapSateliteButton)
        addSubview(mapNomalButton)
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        mapNomalButton.anchor(top: topAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight: 20)
        mapSateliteButton.anchor(top: mapNomalButton.bottomAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight:20,
                              bottom: bottomAnchor,paddingBottom: 10)
        
      
    
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MapViewController:mapCellDelegate {
    func toDetailWithMapCell(discription: Discription) {
        print("遷移mapから")
        let vc = detailViewController()
       
        vc.discription = discription
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func toDetailWithMapCell(discription: Discription, selectImage: UIImage) {
        let vc = detailViewController()
        vc.discription = discription
        vc.image = selectImage
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension MapViewController :transitionDelegate{
    func scroll() {}
    func toEditPageWithProfileCell(){}
    func toFriendList() {
        let vc = FriendListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toDetailWithDiscriptionpCell(discription: Discription) {
        print("遷移")
        let vc = detailViewController()
        vc.discription = discription
  
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func toDetailWithDiscriptionpCell(discription: Discription,selectImage:UIImage) {
        let vc = detailViewController()
        vc.discription = discription
        vc.image = selectImage
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

