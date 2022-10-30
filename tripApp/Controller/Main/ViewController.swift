
import UIKit
import MapKit
import GoogleMobileAds



class MapViewController: BaseViewController, reloadDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    let menuView = MenuView()
    
    var postButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")
        button.tintColor = .white
        button.setImage(image, for: .normal)
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

    var mapCell:MapCell?
    var mapAndDiscriptionCell:MapAndDiscriptionCell?
    
    let refresher = UIRefreshControl()
    var articles = [Article]()
    var selectArticle:Article?
    var selectImage = UIImage()
    var isReload = false
    let settingLancher = SettingLancher()
    
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
        view.addSubview(menuView)
        
        addConstraint()
        postButton.addTarget(self, action: #selector(showSettingView(sender:)), for: .touchUpInside)
        getDiscription()

        setupNavigationItems()
        settingCollectionView()
        
        settingLancher.postButton.addTarget(self, action: #selector(pushPostVC), for: .touchDown)
        settingLancher.cameraButton.addTarget(self, action: #selector(openCamera), for: .touchDown)
        
        print("LanguageManager.shered.getlocation()",LanguageManager.shered.getlocation())
        
        
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        //投稿してこの画面に戻ってきたら最新の投稿を表示するためにリロードする
        if isReload {
            getDiscription()
            isReload = false
        }
    }
    
   
    @objc func openCamera(){
        settingLancher.handleDismiss()
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes  = ["public.movie","public.image"]
        picker.delegate = self
        picker.videoMaximumDuration = 30
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("写真を撮りました")
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            //postviewに遷移する
            let vc = PostViewController()
            vc.isCamera = true
            vc.isVideo = true
            vc.videoURL = videoURL
           
            navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: false, completion: nil)
               
        }
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        
            //postviewに遷移する
            let vc = PostViewController()
            vc.isCamera = true
            vc.isVideo = false
            vc.image = editingImage
            navigationController?.pushViewController(vc, animated: true)
            picker.dismiss(animated: false, completion: nil)
        }
        picker.dismiss(animated: false, completion: nil)
    }
    @objc func pushPostVC(){
        settingLancher.handleDismiss()
        let vc = PostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc internal func showSettingView(sender: UIButton) {
        settingLancher.showSetting(frame: postButton.frame)
    }

    @objc func pushSettingVC(){
        let layout = UICollectionViewFlowLayout()
        let vc = SettingViewController(collectionViewLayout: layout)
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
     }
  
   
    @objc func getDiscription(){
      //自分の投稿と友達の投稿あとprofileを取得する
        articles = []
        
        FirebaseManager.shered.getFriendDiscription { [self] result in
            refresher.endRefreshing()
            articles.append(contentsOf: result)
            print(articles)
            collectionView.reloadData()
        }
    
    }

}

extension MapViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func reload() {
        if menuView.selectedIndexPath?.row == 0{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 0, section: 0) , at: .centeredHorizontally, animated: true)
        }
        else{
            mapAndDiscriptionCell?.collectionView.scrollToItem(at:IndexPath(row: 1, section: 0) , at: .centeredHorizontally, animated: true)
        }
    }
   
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapAndDiscriptionCell", for: indexPath) as! MapAndDiscriptionCell
        
        cell.discriptioncell.delegate = self
        cell.mapCell.delegateWithMapCell = self
        cell.discriptioncell.isHome = true
        cell.discriptionList = articles
        cell.viewWidth = view.frame.width
        mapAndDiscriptionCell = cell

       
        return cell
            
        
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 83
        let height = view.frame.height - statusBarHeight - navigationBarHeight - tabbarHeight
        print("height",height)
        
        return CGSize(width: view.frame.width, height:height)
       
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
        postButton.backgroundColor = .link
        postButton.layer.cornerRadius = view.frame.width / 14
        postButton.clipsToBounds = true
       
        collectionView.anchor( left: view.leftAnchor, paddingLeft: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0 )
        menuView.menuBarTitleArray = ["house","map"]
        menuView.delegate = self
        menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                        left: view.leftAnchor, paddingLeft: 0,
                        right: view.rightAnchor, paddingRight: 0,
                        bottom: collectionView.topAnchor, paddingBottom: 0 ,height: 40)
    }


    func settingCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MapCell.self, forCellWithReuseIdentifier: "MapCell")
        collectionView.register(MapAndDiscriptionCell.self, forCellWithReuseIdentifier: "MapAndDiscriptionCell")
        refresher.addTarget(self, action: #selector(getDiscription), for: .valueChanged)
        collectionView.addSubview(refresher)
        
    }


    func setupNavigationItems(){
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.font = UIFont(name: "Times New Roman", size: 20)
        titleLabel.text = "PhotoShare"
        titleLabel.tintColor = .darkGray
        navigationItem.titleView = titleLabel
        let accountImage = UIImage(systemName: "text.justify")
        let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(pushSettingVC))
        
        navigationItem.rightBarButtonItems = [accountItem]
        navigationController?.navigationBar.tintColor = .darkGray
    }
    
}




extension MapViewController:mapCellDelegate {
    func toDetailWithMapCell(discription: Article) {
        print("遷移mapから")
        let vc = detailViewController()
        vc.discription = discription
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func toDetailWithMapCell(discription: Article, selectImage: UIImage) {
        print("遷移mapから")
        let vc = detailViewController()
        vc.discription = discription
        vc.image = selectImage
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension MapViewController :transitionDelegate{
    func showMenu(disc: Article, profile: Profile) {
        if disc.userid != FirebaseManager.shered.getMyUserid() {
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            if LanguageManager.shered.getlocation() == "ja" {
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
                //英語
                let alertA = UIAlertAction(title: "Report \(profile.username)", style: .default) {  action in
                    print("通報する")
                    self.reportAlert(disc: disc)
                }
                let alertB = UIAlertAction(title: "Block \(profile.username)", style: .default) {  action in
                    self.blockFriend(userid: disc.userid)
                }

                let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { action in print("キャンセル")}
                  
                myAlert.addAction(alertA)
                myAlert.addAction(alertB)
                myAlert.addAction(cancelAlert)
                
                present(myAlert, animated: true, completion: nil)
            }
           
        }
        else {
            //自分の投稿
            let myAlert: UIAlertController = UIAlertController(title:"" , message: "", preferredStyle: .actionSheet)
            myAlert.view.backgroundColor = .systemGray6
            if LanguageManager.shered.getlocation() == "ja" {
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
            else {
                let alertA = UIAlertAction(title: "Edit privacy", style: .default) {  action in
                    print("公開範囲変更")
                    //もし24時間以内ならfrienddiscを変更する
                    let vc = FriendListViewController()
                    vc.isEditView = true
                    vc.disc = disc
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                let alertB = UIAlertAction(title: "Delete Post", style: .default) {  action in
                    print("投稿を削除する")
                    self.deleteAlert(disc: disc)
                    
                }
                let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel) { action in
                       print("キャンセル")
                }
                
              myAlert.addAction(alertA)
              myAlert.addAction(alertB)
              myAlert.addAction(cancelAlert)
              
              present(myAlert, animated: true, completion: nil)

            }
           
           
         
        }
    }
    func deleteAlert(disc:Article){
        
        
        if LanguageManager.shered.getlocation() == "ja" {
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
                    self.completeAlert(text: "削除が完了しました")
                })
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                alert.addAction(selectAction)
                alert.addAction(cancelAction)

                present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Post?", preferredStyle: .actionSheet)
            let selectAction = UIAlertAction(title: "Delete", style: .default, handler: { _ in
                DataManager.shere.delete(id: disc.id)
                FirebaseManager.shered.deleteDiscription(postID: disc.id)
            
                    if disc.type == "image"{
                        StorageManager.shered.deleteDiscriptionImage(image:disc.data)
                    }else{
                        StorageManager.shered.deleteDiscriptionVideo(video: disc.data)
                        //todo ビデオをとめる
                    }
                    self.getDiscription()
                    self.completeAlert(text: "Post has been successfully deleted.")
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(selectAction)
                alert.addAction(cancelAction)

                present(alert, animated: true)
        }
    }
    
    func reportAlert(disc:Article){
        if LanguageManager.shered.getlocation() == "ja" {
            let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
                   
                // userid, post id と 報告内容
                   let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
                       let report = "嫌がらせ・差別・誹謗中傷"
                     
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                       
                      
                       print(report)
                       completeAlert(text: "報告が完了しました")
                   }
                   let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                       let report = "内容が著しく事実と異なる"
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                      
                       completeAlert(text: "報告が完了しました")
                       print(report)
                   }
                   let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
                      
                       let report = "性的表現"
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                      
                       print(report)
                       completeAlert(text: "報告が完了しました")
                   }
                let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
                       
                        let report = "不適切な投稿"
                    FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
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
        else {
            let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
                   
                // userid, post id と 報告内容
            
                   let alertA = UIAlertAction(title: "Harassment/Discrimination/slander", style: .default) { [self] action in
                       let report = "嫌がらせ・差別・誹謗中傷"
                     
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                       
                      
                       print(report)
                       completeAlert(text: "報告が完了しました")
                   }
                   let alertC = UIAlertAction(title: "violent or repulsive content", style: .default) { [self] action in
                       let report = "暴力的なコンテンツ"
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)

                       completeAlert(text: "報告が完了しました")
                       print(report)
                   }
                   let alertD = UIAlertAction(title: "Sextual Content", style: .default) { [self] action in
                      
                       let report = "性的表現"
                       FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
                      
                       print(report)
                       completeAlert(text: "報告が完了しました")
                   }
                let alertE = UIAlertAction(title: "Other", style: .default) { [self] action in
                       
                        let report = "不適切な投稿"
                    FirebaseManager.shered.report(article: disc, userid:FirebaseManager.shered.getMyUserid(), category: report)
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
       
    }
    
    func scroll(){}
    func toEditPageWithProfileCell(){}
    
    func toFriendList() {
        let vc = FriendListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //discriptioncellから遷移
    func toDetailWithDiscriptionpCell(discription: Article) {
        print("遷移")
        let vc = detailViewController()
        vc.discription = discription
        vc.isMapVC = true
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    func toDetailWithDiscriptionpCell(discription: Article,selectImage:UIImage) {
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




class SettingLancher: NSObject{

    //bottomMenubarをキャンセルのところBottomMenuBarにする
    let backView = UIView()
    let postButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        return button
    }()
    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()


    var frame = CGRect()
    
    override init() {
        super.init()
        backButton.addTarget(self, action: #selector(back), for: .touchDown)
        
    }
    func showSetting(frame:CGRect){
        print("show setting",frame)
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }){
           print("window ok")
            self.frame = frame
            backView.backgroundColor = UIColor(white: 0, alpha: 0.8)
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            backView.frame = window.frame
            backView.alpha = 0

            window.addSubview(backView)
            backView.addSubview(cameraButton)
            backView.addSubview(postButton)
            backView.addSubview(backButton)
            cameraButton.backgroundColor = .white
            postButton.backgroundColor = .white
            backButton.backgroundColor = .link
            
            cameraButton.layer.cornerRadius = frame.width / 2
            postButton.layer.cornerRadius = frame.width / 2
            backButton.layer.cornerRadius = frame.width / 2
            
            cameraButton.clipsToBounds = true
            postButton.clipsToBounds = true
            backButton.clipsToBounds = true
            
            
            
            cameraButton.frame = CGRect(x: frame.minX ,y: frame.minY, width: frame.width, height: frame.width)
            postButton.frame   = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
            backButton.frame   = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backView.alpha = 1
                self.cameraButton.frame = CGRect(x: frame.minX, y: frame.minY - 140, width: frame.width, height: frame.width)
                self.postButton.frame   = CGRect(x: frame.minX, y: frame.minY - 70, width: frame.width, height: frame.width)
                self.backButton.isHidden = false
            }, completion: nil)

            
        }
    }
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.backView.alpha = 0
            
            if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil{
                cameraButton.frame = CGRect(x: frame.minX ,y: frame.minY, width: frame.width, height: frame.width)
                postButton.frame   = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
                backButton.isHidden = true
            }
        }
    }
    
    @objc func back() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.backView.alpha = 0
            if UIApplication.shared.windows.first(where: { $0.isKeyWindow }) != nil{
                cameraButton.frame = CGRect(x: frame.minX ,y: frame.minY, width: frame.width, height: frame.width)
                postButton.frame   = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.width)
                backButton.isHidden = true
            }
        }
    }
    
    func createStackView(title:String) -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .vertical
        let label = UILabel()
        label.textAlignment = .right
        label.text = title
        stackView.addSubview(label)
        return stackView
    }
}

