//
//  PostView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/09.
//

import Foundation
import UIKit

import CoreLocation
import Photos
import CropViewController
import PKHUD
import AVFoundation

class PostViewController:UIViewController,UITextViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    var isVideo = false
    var videoPlayer:VideoPlayer = {
        let view = VideoPlayer()
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    var location:Location?
    var isLocation = false
    
    var friendList = [Friend]()
    var friendListView: FriendListView =  {
        let view = FriendListView()
        view.isHidden = true
        return view
    }()
    
    var videoUrl = URL(string: "")
    var isOpen = false
    let openFriendListButton:UIButton = {
        let button = UIButton()
        button.setTitle("公開範囲 ▼", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.contentHorizontalAlignment = .center
        button.tintColor = .lightGray
        
        return button
    }()
    let closeImageViewButton:UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        
        return button
    }()
    
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var placeholderLabel : UILabel!
    
    var imageArray = [UIImage]()
    let selectImageView:UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .systemGray6
        imageview.image = UIImage(systemName: "photo")
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
   
    let locationButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("位置情報を追加", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left

        return button
    }()
    let uiview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "投稿画面"
        self.view.backgroundColor = .white
        
        
        
        addConstraints()
        checkAuthorizationPHPhotoLibrary()
        
        setupNavigationItems()
        settingTextViewPlaceHolder()
        settingZPositon()
        settingButton()
        
        friendList = FollowManager.shere.getFollow()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    func settingButton(){
        locationButton.addTarget(self, action: #selector(getMyLocation(sender:)), for: .touchUpInside)
        openFriendListButton.addTarget(self, action: #selector(showFriendListView(sender:)), for: .touchUpInside)
        closeImageViewButton.addTarget(self, action: #selector(closeImage(sender:)), for: .touchUpInside)
        let tapimage = UITapGestureRecognizer(target: self, action: #selector(selectImage(sender:)))
        selectImageView.addGestureRecognizer(tapimage)
    }
  
    func checkAuthorizationPHPhotoLibrary(){
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { [self] status in
                if status == .authorized {
                    // フォトライブラリを表示する
                    
                } else if status == .denied {
                    // フォトライブラリへのアクセスが許可されていないため、アラートを表示する
                    let alert = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "設定", style: .default, handler: { (_) -> Void in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
                            return
                        }
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    })
                    let closeAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
                    alert.addAction(settingsAction)
                    alert.addAction(closeAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            // フォトライブラリを表示する
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
      
    }
   
    
    func settingZPositon(){
        locationButton.layer.zPosition = 1
        friendListView.layer.zPosition = 1
        openFriendListButton.layer.zPosition = 1
        
    }
    func setupNavigationItems(){
        navigationController?.navigationBar.shadowImage = UIImage()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let backItem  = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(back))
        let postItem = UIBarButtonItem(title: "送信", style: .plain, target: self, action: #selector(post))
        backItem.tintColor = .link
        postItem.tintColor = .link
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = postItem
        
    }
    
    @objc func showFriendListView(sender: UIButton){
        print("tapppppppp")
        isOpen = !isOpen
        if isOpen {
            openFriendListButton.setTitle("閉じる ▲", for: .normal)
            friendListView.friendList = friendList
            friendListView.isHidden = false
            friendListView.isUserInteractionEnabled = true
            
        }
        else{
            openFriendListButton.setTitle("公開範囲 ▼", for: .normal)
            friendListView.isHidden = true
            friendListView.isUserInteractionEnabled = false
        }
    }
    @objc func closeImage(sender: UIButton){
        closeImageViewButton.isHidden = true
        //初期化
        selectImageView.isHidden = false
        videoPlayer.isHidden = true
        videoPlayer.player = AVPlayer()
        selectImageView.image = UIImage(systemName: "photo")
        
    }
    @objc  func post(){
        
       
        //画像が選択されている
        //ロケーションが設定されている
        //フレンドリストが表示されていない　場合に投稿する

        if isVideo && textView.text.count != 0 && isLocation && !isOpen {
            //動画の場合
            print("動画")
            
            let userid = FirebaseManager.shered.getMyUserid()
            HUD.show(.progress)
            StorageManager.shered.uploadMovie(videourl: videoUrl!){ [self] result in
                let disc = Discription(id: String().generateID(10),
                                       userid: userid,
                                       text:   textView.text,
                                       location: location,
                                       image: ProfileImage(url:result.url, name: result.name),
                                       created: Date(), type: "video")
                var data = DataManager.shere.get()
                data.append(disc)
                DataManager.shere.save(data: data)
                FirebaseManager.shered.postDiscription(disc: disc)
                HUD.hide()
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! MapViewController
                preVC.isReload = true
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if isVideo == false && textView.text.count != 0 &&
                    isLocation && !isOpen{
            //画像の場合
            print("画像")
            let image = selectImageView.image
            let userid = FirebaseManager.shered.getMyUserid()
            HUD.show(.progress)
            
            StorageManager.shered.uploadImage(imageData: image!.convert_data()) { [self] (result) in
                
                let disc = Discription(id: String().generateID(10),
                                       userid: userid,
                                       text:   textView.text,
                                       location: location,
                                       image: ProfileImage(url:result.url, name: result.name),
                                       created: Date(), type: "image")
                
                var data = DataManager.shere.get()
                data.append(disc)
                DataManager.shere.save(data: data)
                FirebaseManager.shered.postDiscription(disc: disc)
                HUD.hide()
                let nav = self.navigationController
                let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! MapViewController
                preVC.isReload = true
                self.navigationController?.popViewController(animated: true)
                
            }
       
        }
        else{
            var message = ""
            if !isOpen{
                
            }
            else if selectImageView == UIImage()  {
                message = "画像が選択されていません"
                alert(message: message)
            }
            else if textView.text.isEmpty == true{
                message = "本文が入力されていません"
                alert(message: message)
            }
            else if isLocation == false {
                alert(message: "位置情報を追加されていません")
            }

        }
       
        
    }
    @objc func back(){
        print("前の画面に戻る")
//        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    @objc  func getMyLocation (sender: UIButton){
        print("位置情報を取得")
//        setupLocationManager()
        let vc = SelectLocationMapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addConstraints(){
        
        view.addSubview(textView)
        view.addSubview(locationButton)
        view.addSubview(selectImageView)
        view.addSubview(friendListView)
        view.addSubview(openFriendListButton)
        view.addSubview(videoPlayer)
        view.addSubview(closeImageViewButton)
        
        videoPlayer.setup()
        videoPlayer.setupVideoTap()
        selectImageView.anchor(left:view.leftAnchor, paddingLeft: 10,
                               right: view.rightAnchor, paddingRight: 10,
                               height: view.frame.width)
        videoPlayer.anchor( left:view.leftAnchor, paddingLeft: 0,
                            right: view.rightAnchor, paddingRight: 0,
                            height: view.frame.width)
        
        closeImageViewButton.anchor(top: selectImageView.topAnchor, paddingTop: 10,
                                    right: selectImageView.rightAnchor, paddingRight: 10
                               
                                   )
        textView.anchor(top: locationButton.bottomAnchor, paddingTop: 5,
                        left: view.leftAnchor, paddingLeft: 0,
                        right: view.rightAnchor, paddingRight: 0)
        
        
        
        
        friendListView.backgroundColor = .white
        friendListView.layer.zPosition = 1
        friendListView.anchor(top: view.topAnchor, paddingTop: 0,
                              left: view.leftAnchor, paddingLeft: 0,
                              right: view.rightAnchor, paddingRight: 0,
                              bottom: view.bottomAnchor,paddingBottom: -view.frame.width / 5)
        friendListView.height = view.frame.height
        
        openFriendListButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop:  2,
                                    right: view.rightAnchor,paddingRight: 2,
                                    width: 100,
                                    height: 20)
        
    
        
        
        locationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2,
                              left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 15,
                              right: openFriendListButton.leftAnchor, paddingRight: 5,
                              height: 20)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 1.5, animations: { [self] () -> Void in
            
            friendListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardFrame.size.height ).isActive = true
            
            let imageWidth =  view.frame.width
            let cvHeight = view.frame.width / 5
            selectImageView.anchor(bottom: view.bottomAnchor,paddingBottom: keyboardFrame.size.height - imageWidth / 2 + cvHeight ,
                                   height: view.frame.width)
            videoPlayer.anchor(bottom: view.bottomAnchor,paddingBottom: keyboardFrame.size.height - imageWidth / 2 + cvHeight ,
                                   height: view.frame.width)
            
            textView.anchor(bottom: selectImageView.topAnchor, paddingBottom: 0)
            friendListView.layoutIfNeeded()
            selectImageView.layoutIfNeeded()
            videoPlayer.layoutIfNeeded()
        })
        
    }
   
    
    func settingTextViewPlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "出来事を記録しましょう"
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 15, y: 20)
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        textView.becomeFirstResponder()
        textView.delegate = self
    }
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        self.location = Location(latitude:latitude! , longitude: longitude!)
        
        //少しだけ座標をずらしている -> 結局ずらしてない
        //全く同じ場所で三回投稿するとmapでpinを選択できず、詳細画面に遷移できなくなるから
//        let fixLatitude = latitude! + generateRondomDouble()
//        let fixLongitude = longitude! + generateRondomDouble()
        
        let Location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        CLGeocoder().reverseGeocodeLocation(Location) { [self] placemarks, error in
            if let placemark = placemarks?.first {
                print(placemark)
                let country = String(placemark.country!)
                let locality = placemark.locality
                let subLocality = placemark.subLocality
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
                    let text = "\(String(country + Area + locality! + subLocality!))"
                    locationButton.setTitle(text,for:.normal)
                }
                else{
                    let text = "\(String(country + locality! + subLocality!))"
                    locationButton.setTitle(text,for:.normal)
                }
                locationButton.setTitleColor(.link, for: .normal)
                isLocation = true
            }
        }
    }
    func alert(message: String){
        let alert = UIAlertController(title: "報告", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func generateRondomDouble() -> Double{
        let i = Int.random(in: -1 ... 1)
        return Double(i) *  0.000000000001
    }
}



extension PostViewController:CropViewControllerDelegate{
    //mdium       3.0mg
    //type640x480 2.36mg
    //low         603kb
    
    @objc func selectImage(sender:UITapGestureRecognizer){
        //画像であれば　正方形にカットする
        //サブスクリプションユーザーならば　動画も投稿できるようにする
//        picker.mediaTypes = ["public.image"]
       
 
            let picker = UIImagePickerController()
            picker.sourceType = .savedPhotosAlbum
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.delegate = self
            picker.videoQuality = .typeMedium
            picker.videoMaximumDuration = 30
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
       
        picker.dismiss(animated: true) { [self] in
            textView.becomeFirstResponder()
            closeImageViewButton.isHidden = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            videoUrl = videoURL
            videoPlayer.isHidden = false
            closeImageViewButton.isHidden = false
            selectImageView.isHidden = true
            isVideo = true
            print("videoUrl",videoUrl!)
            videoPlayer.player = AVPlayer(url: videoUrl!)
            picker.dismiss(animated: false, completion: nil)
           
        }
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("editind")
            videoPlayer.isHidden = true
            closeImageViewButton.isHidden = false
            selectImageView.isHidden = false
            selectImageView.image = editingImage
            picker.dismiss(animated: false, completion: nil)
        }
        else {
            if let original = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                print("original")
                let cropController = CropViewController(croppingStyle: .default, image: original)
                cropController.delegate = self
                cropController.customAspectRatio = CGSize(width: view.frame.width, height: view.frame.width)
                cropController.aspectRatioPickerButtonHidden = true
                cropController.resetAspectRatioEnabled = false
                cropController.rotateButtonsHidden = true
                videoPlayer.isHidden = true
                closeImageViewButton.isHidden = false
                cropController.cropView.cropBoxResizeEnabled = false

                picker.dismiss(animated: true) {
                    self.present(cropController, animated: true, completion: nil)
                }
            }
        }
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{ return }
        

        
        
       
        
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else {  return }
        
        selectImageView.image = UIImage(data: imageData)
        closeImageViewButton.isHidden = false
        
        cropViewController.dismiss(animated: true) { [self] in
            textView.becomeFirstResponder()
           
          
        }
    }
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true){ [self] in
            textView.becomeFirstResponder()
            closeImageViewButton.isHidden = true
        }
    }
}





extension PostViewController{
    
  
    
    
 
    
    
    func getimg(){
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assetCollections = PHAssetCollection.fetchAssetCollections(with:.smartAlbum , subtype: .smartAlbumUserLibrary, options:nil)
        
        assetCollections.enumerateObjects { assetCollection, _, _ in
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            let imageCount = 10
            for i in 0..<imageCount{
                let asset = assets.object(at: i) as PHAsset
                imgManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:.aspectFit, options: requestOptions, resultHandler: { img, info in
                    
                    
                    let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
                    if isDegraded {
                        return
                    }
                    
                    //これがないと同じ画像が表示される
                    if let img = img {
                        if self.imageArray.count == imageCount * 2{
                            return
                        }
                        else{
                            print(i + 1 ,"回目")
                            self.imageArray.append(img)
                        }
                        
                        
                        
                    }
                })
                
            }
            DispatchQueue.main.async {
                print("dispath")
//                self.collectionView.reloadData()
            }
        }
    }
}











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
        cell.setCell(imageurl: profileList[indexPath.row].profileImageUrl, username: profileList[indexPath.row].username, friend: friendList![indexPath.row], index: indexPath.row)
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    
}

