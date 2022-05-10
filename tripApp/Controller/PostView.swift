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

class PostViewController:UIViewController,UITextViewDelegate,CLLocationManagerDelegate{
    var selectedIndexPath: IndexPath?
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    var location:Location?
    let textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var placeholderLabel : UILabel!
    var imageArray = [UIImage]()
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.isHidden = true
        cv.backgroundColor = .systemGray6
        return cv
    }()
    
    let locationButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("位置情報を追加する", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.systemGray2, for:.highlighted )
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "投稿画面"
        self.view.backgroundColor = .white
        view.addSubview(textView)
        view.addSubview(collectionView)
        view.addSubview(locationButton)
        addConstraintTextView()
        addConstraintCollectionView()
        
        setupNavigationItems()
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        textView.becomeFirstResponder()
        textView.delegate = self
        settingTextViewPlaceHolder()
        locationButton.addTarget(self, action: #selector(getMyLocation(sender:)), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        getimg()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
                   self,
                   selector:#selector(keyboardWillShow(_:)),
                   name: UIResponder.keyboardWillShowNotification,
                   object: nil
                 )
    }
    func setupNavigationItems(){
        navigationController?.navigationBar.shadowImage = UIImage()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
       
        let backItem  = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(back))
        let postItem = UIBarButtonItem(title: "投稿する", style: .plain, target: self, action: #selector(post))
        backItem.tintColor = .link
        postItem.tintColor = .link
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = postItem
        
    }
    @objc  func post(){
        if let image = imageArray[selectedIndexPath!.row] as UIImage?,
           let text = textView.text{
            let diary = Diary(id: String().generateID(7), image:image.convert_data() , text: text, date: Date(), location: location)
                var data = DataManager.shere.get()
                data.append(diary)
            print(data.count)
                DataManager.shere.save(data: data)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else{
            //alert
            print("画像を選択してください")
        }

       
     }
     @objc func back(){
         print("前の画面に戻る")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
     }
    @objc  func getMyLocation (sender: UIButton){
        print("位置情報を取得")
        setupLocationManager()
     }
    func addConstraintTextView(){
        textView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        textView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    func addConstraintCollectionView(){
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 5.0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        

        locationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
         
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
          
          UIView.animate(withDuration: 1.5, animations: { [self] () -> Void in
            collectionView.isHidden = false
            
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardFrame.size.height - 5).isActive = true
            locationButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant:  0).isActive = true
            collectionView.layoutIfNeeded()
            locationButton.layoutIfNeeded()
          })
          
       }
    
    func settingTextViewPlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "出来事を記録しましょう"
      
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 15, y: 20)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
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
        
        
        let Location = CLLocation(latitude: latitude!, longitude: longitude!)
        CLGeocoder().reverseGeocodeLocation(Location) { [self] placemarks, error in
            if let placemark = placemarks?.first {
                print(placemark)
                let country = String(placemark.country!)
                let locality = placemark.locality
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
                    let text = "\(String(country + Area + locality!))"
                    locationButton.setTitle(text,for:.normal)
                }
                else{
                    let text = "\(String(country + locality!))"
                    locationButton.setTitle(text,for:.normal)
                }
            }
        }
    }

}



extension PostViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == 0{
            return 0
        }
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.imageView.image = imageArray[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .darkGray
        if  selectedIndexPath?.row == indexPath.row{
                cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height , height:collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           selectedIndexPath = indexPath
         
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

        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options:nil)
        assetCollections.enumerateObjects { assetCollection, _, _ in
            let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            for i in 0..<10{
                let asset = assets.object(at: i) as PHAsset
                imgManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:.aspectFit, options: requestOptions, resultHandler: { img, aa in
                   
                    if let img = img {
                        print("画像の取得に成功")
                        self.imageArray.append(img)
                                    
                    }
                })
                         
            }
          

            
                  
        self.collectionView.reloadData()
        }
    }
}

