
import UIKit
import MapKit
import CoreLocation
import Photos
import PKHUD
import SwiftUI


class MapViewController: BaseViewController, reloadDelegate{
 

    
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
    let menuBar :DetailMenuBar = {
        let menu = DetailMenuBar()
        let menuArray = [Menu(title: "通報する", image:"flag" ),Menu(title: "ブロックする", image:"circle.slash"),Menu(title: "ARで場所を見る", image:"camera" )]
        menu.layer.cornerRadius = 10
        menu.clipsToBounds = true
        menu.setData(array: menuArray)
        menu.tag = 1
        return menu
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
    var isShow = false
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
        getDiscription()

        setupNavigationItems()
        settingCollectionView()
      
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        if isReload {
            getDiscription()
            isReload = false
        }
    }
    
    @objc internal func sendtoPostView(sender: UIButton) {
     
            let vc = PostViewController()
            navigationController?.pushViewController(vc, animated: true)
       
       
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("tapppp")
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("tapppp")
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
                              bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0 )
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




extension MapViewController:mapCellDelegate {
    func toDetailWithMapCell(discription: Discription) {
        print("遷移mapから")
        let vc = detailViewController()
       
        vc.discription = discription
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func toDetailWithMapCell(discription: Discription, selectImage: UIImage) {
        print("遷移mapから")
        let vc = detailViewController()
        vc.discription = discription
        vc.image = selectImage
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension MapViewController :transitionDelegate{
    func showMenu(disc: Discription, profile: Profile) {
        if disc.userid != FirebaseManager.shered.getMyUserid() {
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            let alertA = UIAlertAction(title: "\(profile.username)さんを通報する", style: .default) {  action in
                print("通報する")
                self.reportAlert(disc: disc)
            }
            let alertB = UIAlertAction(title: "\(profile.username)さんをブロックする", style: .default) {  action in
                self.blockFriend(userid: disc.userid)
            }

            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in print("キャンセル")}
              
            myAlert.addAction(alertA)
            myAlert.addAction(alertB)
            myAlert.addAction(cancelAlert)
            
            present(myAlert, animated: true, completion: nil)
        }
        else {
            //自分の投稿
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            let alertA = UIAlertAction(title: "公開範囲を変更する", style: .default) {  action in
                print("公開範囲変更")
                //もし24時間以内ならfrienddiscを変更する
                let vc = FriendListViewController()
                vc.isEditView = true
                vc.disc = disc
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            let alertB = UIAlertAction(title: "投稿を削除する", style: .default) {  action in
                print("投稿を削除する")
                self.deleteAlert(disc: disc)
                
            }

            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                   print("キャンセル")
            }
              
            myAlert.addAction(alertA)
            myAlert.addAction(alertB)
            myAlert.addAction(cancelAlert)
            
            present(myAlert, animated: true, completion: nil)
        }
    }
    func deleteAlert(disc:Discription){
        let alert = UIAlertController(title: "報告", message: "削除してもよろしいですか？", preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "削除する", style: .default, handler: { _ in
            DataManager.shere.delete(id: disc.id)
            FirebaseManager.shered.deleteDiscription(postID: disc.id)
        
                if disc.type == "image"{
                    StorageManager.shered.deleteDiscriptionImage(image:disc.data)
                }else{
                    StorageManager.shered.deleteDiscriptionVideo(video: disc.data)
                    //todo ビデオをとめる
                }
                self.getDiscription()
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
    }
    
    func reportAlert(disc:Discription){
        let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
               
            // userid, post id と 報告内容
               let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
                   let report = "嫌がらせ・差別・誹謗中傷"
                 
                       FirebaseManager.shered.report(disc: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                   
                  
                   print(report)
                   completeAlert(text: "報告が完了しました")
               }
               let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                   let report = "内容が著しく事実と異なる"
                   FirebaseManager.shered.report(disc: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                  
                   completeAlert(text: "報告が完了しました")
                   print(report)
               }
               let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
                  
                   let report = "性的表現"
                   FirebaseManager.shered.report(disc: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                  
                   print(report)
                   completeAlert(text: "報告が完了しました")
               }
            let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
                   
                    let report = "不適切な投稿"
                FirebaseManager.shered.report(disc: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                    print(report)
                    completeAlert(text: "報告が完了しました")
                }
        
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                   print("キャンセル")
               }
               // OKのActionを追加する.
               myAlert.addAction(alertA)
               myAlert.addAction(alertC)
               myAlert.addAction(alertD)
               myAlert.addAction(alertE)
               myAlert.addAction(cancelAlert)
               

               // UIAlertを発動する.
               present(myAlert, animated: true, completion: nil)
    }
    
    func scroll(){}
    func toEditPageWithProfileCell(){}
    func toFriendList() {
        let vc = FriendListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //discriptioncellから遷移
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
    
    func blockFriend(userid:String){
        //ブロックする
        FollowManager.shere.block(userid: userid)
        //フォローを解除する
        FollowManager.shere.unfollow(userid: userid)
//        FirebaseManager.shered.unfollow(friendid: discription!.userid)
        //前の画面に戻る
        collectionView.reloadData()
        //ブロックした人の投稿は見れないようにする
        
        
    }
}



