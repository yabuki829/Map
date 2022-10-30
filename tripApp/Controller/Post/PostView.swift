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

class PostMenuBar :baseView {

  
    let imageButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
        return button
    }()
    let sendButton:UIButton = {
        let button = UIButton()
        if LanguageManager.shered.getlocation() == "ja"{
            button.setTitle("投稿", for: .normal)
        }
        else {
            button.setTitle("Post", for: .normal)
        }
      
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.contentHorizontalAlignment = .center
        return button
    }()
    let wordCountLabel:UILabel = {
        let label = UILabel()
        label.text = "0 / 120"
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    override func setupViews() {
        self.backgroundColor = .systemGray6
        addSubview(imageButton)
        addSubview(sendButton)
        addSubview(wordCountLabel)
        imageButton.anchor(top: topAnchor, paddingTop: 10,
                          left: leftAnchor, paddingLeft: 10,
                          bottom: bottomAnchor, paddingBottom:10,width:20,height: 20)
        sendButton.anchor(top: topAnchor, paddingTop: 10,
                          right: rightAnchor, paddingRight: 0,
                          bottom: bottomAnchor, paddingBottom:10,width:80,height: 20)
        wordCountLabel.anchor(top: topAnchor, paddingTop: 10,
                              left: imageButton.rightAnchor,paddingLeft: 5,
                              right: sendButton.leftAnchor,paddingRight: 5,
                              bottom: bottomAnchor, paddingBottom:10
        )
    }
}



class PostViewController:UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    
    var postCell = postViewCell()
    var imageCell = ImageCellwithPost()
    let menuBar = PostMenuBar()
    let tableView = UITableView()
    var isCamera = false
    var isVideo = false
    var videoURL = URL(string: "")
    var image = UIImage()
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = .link
        settingCollectionView()
        addConstraint()
        settingButtonAction()
        imageCell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageCellwithPost
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector:#selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
      
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    
    override var shouldAutorotate: Bool {
        return true
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! postViewCell
        
            cell.delegate = self
            postCell = cell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else {
            
            imageCell.selectionStyle = .none
            if isCamera {
                if isVideo {
                    imageCell.videoView.isHidden = false
                    
                            
                    imageCell.videoView.player = AVPlayer(url: videoURL!)
                    imageCell.videoView.setup()
                    imageCell.videoView.setupVideoTap()
                    imageCell.videourl = videoURL
                    imageCell.isVideo = true
                  
                }
                else{
                    imageCell.imageview.image = image
                    imageCell.isVideo = false
                }
            }
            return imageCell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        tableView.estimatedRowHeight = 50
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        else {
            return view.frame.width
        }
    }
    @objc func keyboardWillShow(_ notification: Notification) {
       
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
     
        UIView.animate(withDuration: 0.5, animations: { [self] () -> Void in
            let tabbarHeight = 83.0
           
            menuBar.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: keyboardFrame.size.height - tabbarHeight )
            menuBar.layoutIfNeeded()
        })
        
    }
    func addConstraint(){
        view.addSubview(tableView)
        view.addSubview(menuBar)
        menuBar.anchor(top:tableView.bottomAnchor,paddingTop: 0,
                       left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                       right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 0,
                       height:40)
        tableView.anchor(top:view.topAnchor,paddingTop: 0,
                         left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                         right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                         bottom: menuBar.topAnchor,paddingBottom: 0)
        
        
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
    func settingCollectionView(){
        tableView.register(postViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ImageCellwithPost.self, forCellReuseIdentifier: "imageCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
    }
    func settingButtonAction(){
        menuBar.imageButton.addTarget(self, action: #selector(addImage(sender:)), for: .touchDown)
        menuBar.sendButton.addTarget(self, action: #selector(post(sender:)), for: .touchDown)
        postCell.openFriendListButton.addTarget(self, action: #selector(open), for: .touchDown)
    }
    
    @objc func open(sender:UIButton){
      print("open friend view")
            
    }
    @objc func post(sender:UIButton){
        
        print("post")
        if imageCell.isVideo == nil || postCell.textView.text.count == 0 || postCell.isLocation == false {
            if imageCell.isVideo == nil {
                if LanguageManager.shered.getlocation() == "ja"{
                    let a = "画像や動画が選択されていません"
                
                    alert(message: a)
                }
                else {
                    let a = "No image or video selected"
                    alert(message: a)
                }
            }
            if postCell.textView.text.count == 0 {
                if LanguageManager.shered.getlocation() == "ja"{
                    let a = "本文が入力されていません"
                
                    alert(message: a)
                }
                else {
                    let a = "No body entered"
                    alert(message: a)
                }
            }
            if postCell.isLocation == false {
                if LanguageManager.shered.getlocation() == "ja"{
                    let a = "位置情報が追加されていません"
                    alert(message: a)
                }
                else{
                    let a = "No location added"
                    alert(message: a)
                }
            }
        }
        else {
            HUD.show(.progress)
            if imageCell.isVideo! {
                let url = imageCell.videourl!
                let userid = FirebaseManager.shered.getMyUserid()
                let asset = AVAsset(url:url )
                
                asset.generateThumbnail {[self] image in
                    let thumnailData = image?.convert_data()
                    StorageManager.shered.uploadMovie(videourl: url, thumnailData: thumnailData!){ [self] result in

                        let disc = Article(id: String().generateID(10),
                                               userid: userid,
                                               text:   postCell.textView.text,
                                               location: postCell.location,
                                               data: ProfileImage(url:result[0].url, name: result[0].name),
                                               thumnail: ProfileImage(url:result[1].url, name: result[1].name),
                                               created: Date(), type: "video")
                        var data = DataManager.shere.get()
                        data.append(disc)
                        DataManager.shere.save(data: data)
                        FirebaseManager.shered.postDiscription(disc: disc){ result in
                            HUD.hide()
                            let nav = self.navigationController
                            // 一つ前のViewControllerを取得する
                            let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! MapViewController
                            preVC.isReload = true
                            self.navigationController?.popViewController(animated: true)

                        }

                    }
                }
            }
            else {
                let image = imageCell.imageview.image
                let userid = FirebaseManager.shered.getMyUserid()
                HUD.show(.progress)

                StorageManager.shered.uploadImage(imageData: image!.convert_data()) { [self] (result) in

                    let disc = Article(id: String().generateID(10),
                                           userid: userid,
                                           text:   postCell.textView.text,
                                           location: postCell.location,
                                           data: ProfileImage(url:result.url, name: result.name),
                                           thumnail: nil,
                                           created: Date(),
                                           type: "image")

                    var data = DataManager.shere.get()
                    data.append(disc)
                    DataManager.shere.save(data: data)
                    FirebaseManager.shered.postDiscription(disc: disc) { result in
                        HUD.hide()
                            //reloadをtrueに変更する
                        let nav = self.navigationController
                        // 一つ前のViewControllerを取得する
                        let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! MapViewController
                        preVC.isReload = true
                        self.navigationController?.popViewController(animated: true)
                    }

            }
        }
    }
    }
    func alert(message: String){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                alert.dismiss(animated: true, completion: nil)
            }
    }
    
}

extension PostViewController:postCellDelegate{
    func toFriendList() {
        let vc = FriendListViewController()
        vc.isPostView = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textfieldDidChange(count: Int, reload: Bool) {
        menuBar.wordCountLabel.text = "\(count) / 120"
        
        if reload {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
       
    }

    
    func toSelectLocation() {
        print("遷移")
        let vc = SelectLocationMapViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}





extension PostViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    //mdium       3.0mg
    //type640x480 2.36mg
    //low         603kb
    

    @objc func addImage(sender:UIButton){
        print("tapimage")
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.delegate = self
        picker.videoQuality = .typeMedium
        picker.videoMaximumDuration = 30
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        picker.dismiss(animated: true) 
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            //サムネイルを作成する videourl
          
            imageCell.videoView.isHidden = false
            imageCell.isVideo = true
                    
            imageCell.videoView.player = AVPlayer(url: videoURL)
            imageCell.videourl = videoURL
           
            picker.dismiss(animated: false, completion: nil)
        }
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("editind")
            imageCell.imageview.image = editingImage
            imageCell.isVideo = false
            picker.dismiss(animated: false, completion: nil)
        }

        picker.dismiss(animated: false, completion: nil)
        
    }
    
    
}






class ImageCellwithPost: BaseTableViewCell {
    
        let imageview:UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        var videourl:URL?
        let videoView = VideoPlayer()
        var isVideo:Bool? {
            didSet {
            
                if isVideo! {
                  
                    imageview.isHidden = true
                    videoView.isHidden = false
                    videoView.backgroundColor = .black
                }
                else{
                    videoView.isHidden = true
                    imageview.isHidden = false
                    imageview.backgroundColor = .black
                }
            }
        }
    override func setupViews() {
        addImageViewConstraint()
    }
    func addImageViewConstraint(){
        contentView.addSubview(imageview)
        contentView.addSubview(videoView)
        imageview.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 10,
                        left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft:10,
                        right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                        bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        videoView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                         left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft:0,
                         right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                         bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        
      
   
   
    }
}
