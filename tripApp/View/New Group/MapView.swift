//
//  MapView.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/14.
//

import Foundation
import UIKit
import MapKit
import AVFoundation


class MapView:baseView,MKMapViewDelegate,CLLocationManagerDelegate{
    weak var delegateWithMapCell:mapCellDelegate? = nil
    let menuButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    var menuView:MenuView = {
        let mv = MenuView()
        mv.isHidden = true
       
        return mv
    }()
    
    var descriptionList : [Discription]?{
        didSet {
            setData()
        }
    }
    var selectImage = UIImage()
    var imageViewArray = [uiimageData]()
    var videoArray = [videoData]()
    var selectIndex :Int?
    var preIndex: Int?
    var selectVideo = VideoPlayer()
    var preVideo = VideoPlayer()
    
    
    
    
    var mapView =  MKMapView()
    var selectDiary:Discription?
    var isOpen = false
    var viewWidth = CGFloat()
    var locationManager: CLLocationManager!
    
    override func setupViews() {
        print("map呼ばれてます")
        backgroundColor = .black
        mapView.delegate = self
        self.addSubview(mapView)
        self.addSubview(menuButton)
        self.addSubview(menuView)
        addConstraint()
        menuButton.addTarget(self, action: #selector(changeMap(sender:)), for: .touchUpInside)
        menuView.mapNomalButton.addTarget(self, action: #selector(toDefalutsMap(sender:)), for: .touchUpInside)
        menuView.mapSateliteButton.addTarget(self, action: #selector(toSateliteMap(sender:)), for: .touchUpInside)
        setupLocationManager()
        
    }

    func addConstraint(){
        mapView.anchor(top: self.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                       left: self.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                       right: self.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                       bottom: self.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        mapView.mapType = .satelliteFlyover
        
        menuButton.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 2,
                          right: safeAreaLayoutGuide.rightAnchor, paddingRight: 2)
        
        menuView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                        right: safeAreaLayoutGuide.rightAnchor, paddingRight: 0)
       
    }
    @objc internal func toDefalutsMap(sender: UIButton) {
        //衛生写真に変更する
        print("デフォルト")
        mapView.mapType = .standard
        menuView.isHidden = true
        isOpen = false
        menuButton.isHidden = false
        
    }
    @objc internal func toSateliteMap(sender: UIButton) {
        //デフォルトに変更する
        print("衛生写真")
        mapView.mapType = .satelliteFlyover
        menuView.isHidden = true
        isOpen = false
        menuButton.isHidden = false
    }
    
    @objc internal func changeMap(sender: UIButton) {
        print(sender.isSelected)
        isOpen = !isOpen
        if isOpen {            //メニューを開く
            menuView.isHidden = false
            menuButton.isHidden = true
        }
        else{
            //menuを閉じる
            menuView.isHidden = true
            menuButton.isHidden = true
        }
    }
    
    @objc internal func zoomout(sender: UIButton) {
       print("zoomout")
        
    }
   
    func getData(){
        print("取得します")
        descriptionList!.removeAll()
        FirebaseManager.shered.getDiscription(userid:FirebaseManager.shered.getMyUserid() ) { (result) in
            print("完了",result.count)
            self.descriptionList = DataManager.shere.get()
            self.setData()
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //viewtitle と discriptionの　titleが同じ
       
        //postid と　id　が同じ
        for i in 0..<descriptionList!.count{
            
            if view.annotation?.subtitle == descriptionList![i].text + descriptionList![i].created.covertString() {
                print("同じ")
                
                
                selectDiary = descriptionList![i]
                
                if descriptionList![i].type == "image"{
                    print("image")
                    for j in 0..<imageViewArray.count {
                        if descriptionList![i].id == imageViewArray[j].postId{
                            print("みつかりました")
                            selectImage = imageViewArray[j].image
                            
                            break
                        }
                    }
                }
                else{
                    for j in 0..<videoArray.count {
                        if descriptionList![i].id == videoArray[j].postId{
                           
                            print("みつかりました!!!!!!!!!!!!!!!!!!!!!!!!!!")
                            if selectVideo.player != nil {
                                
                                print("2回目以降--------------------------------------------")
                                if videoArray[j].video.player != selectVideo.player {
                                    print("別のビデオを再生しています")
                                    selectVideo.stop()
                                }
                                
                                preVideo = selectVideo
                                selectVideo = videoArray[j].video
//                                videoArray[selectIndex!].video.stop()
//                                preIndex = selectIndex
//                                selectIndex = j
                               
                                break
                                
                            }
                            else {
                                print("1回目--------------------------------------------")
                                selectVideo = videoArray[j].video
//                                selectIndex = j
                            }
                           
                    
                            
                        }
                    }
                }
                
                if mapView.region.span.latitudeDelta > 0.00015 {
                    let aa = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)! + 0.21, longitude: (view.annotation?.coordinate.longitude)! )
                    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                        let region = MKCoordinateRegion(center: aa, span: span)
                        mapView.setRegion(region, animated: true)
                        
                }
                
                break
            }
        }
       
    }
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
               switch status {
                   case .notDetermined:
                       manager.requestWhenInUseAuthorization()
                   case .restricted, .denied:
                       break
                   case .authorizedAlways, .authorizedWhenInUse:
                       manager.startUpdatingLocation()
                       break
                   default:
                       break
               }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pinView.canShowCallout = true
        
        
    outLoop: for i in 0..<descriptionList!.count{
        
        if annotation.subtitle == descriptionList![i].text + descriptionList![i].created.covertString() {
            

            let stackview = setStackView()
            let tapStackView = UITapGestureRecognizer(target: self, action: #selector(sendtoDetailView(sender:)))
            let imageView = UIImageView()
            let videoView = VideoPlayer()
            stackview.addGestureRecognizer(tapStackView)
        
            if FirebaseManager.shered.getMyUserid() != descriptionList![i].userid {
                pinView.pinTintColor = .link
            }
           
            
            if descriptionList![i].type == "video"{
                //動画
                videoView.loadVideo(urlString:descriptionList![i].data.url)
                videoView.setup()
                videoView.setupVideoTap()
                videoArray.append(videoData(postId:descriptionList![i].id , video: videoView))
                let button = UIButton()
                    button.setTitle("＞＞", for: .normal)
                    button.setTitleColor(.darkGray, for: .normal)
                    button.setTitleColor(.systemGray3, for: .highlighted)
                    button.contentHorizontalAlignment = .right
                    button.addTarget(self, action: #selector(sendtoDetailView(sender:)), for: .touchUpInside)
                
                    stackview.addArrangedSubview(videoView)

                    stackview.addArrangedSubview(button)
                videoView.anchor(width:viewWidth / 3 * 2, height:  viewWidth / 3 * 2)
                let widthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewWidth / 3 * 2 )
                       stackview.addConstraint(widthConstraint)
                pinView.detailCalloutAccessoryView = stackview
            }
            else{
                // 画像
                imageView.setImage(urlString: descriptionList![i].data.url) { [self] image in
                    let imageView = UIImageView()
                    
                    if  image != nil {
                        imageView.image = image
                        imageViewArray.append(uiimageData(postId: descriptionList![i].id, image: image!))
                        let button = UIButton()
                            button.setTitle("＞＞", for: .normal)
                            button.setTitleColor(.darkGray, for: .normal)
                            button.setTitleColor(.systemGray3, for: .highlighted)
                            button.contentHorizontalAlignment = .right
                            button.addTarget(self, action: #selector(sendtoDetailView(sender:)), for: .touchUpInside)
                    
                            stackview.addArrangedSubview(imageView)
                            stackview.addArrangedSubview(button)
                            stackview.translatesAutoresizingMaskIntoConstraints = false
                          
                            let gcd = MathManager.shered.getGreatestCommonDivisor(Int((image?.size.width)!), Int((image?.size.height)!))
                            let ration = MathManager.shered.calcAspectRation(Double(image!.size.width) ,Double(image!.size.height) , gcd: gcd)
                            let times = MathManager.shered.howmanyTimes(aspectRation: ration)
                            let width = viewWidth / 3 * 2
                      
                            imageView.anchor(height: width * times)
                            
                        let widthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewWidth / 3 * 2 )
                               stackview.addConstraint(widthConstraint)
                            
                            pinView.detailCalloutAccessoryView = stackview
                        
                            
                        }
                        else{
                            print("画像エラー", descriptionList![i].data.url,descriptionList![i].data.name,image)
                        
                        }
                
                    }
            }

         
            }

        
        }
        return pinView
    }
    
    
    func setStackView() -> UIStackView{
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.isUserInteractionEnabled = true
        return stackview
    }
    @objc internal func sendtoDetailView(sender: UIButton) {
        
        if selectDiary?.type == "image"{
            delegateWithMapCell?.toDetailWithMapCell(discription: selectDiary!, selectImage: selectImage)
        }
        else{
          
//            delegateWithMapCell?.toDetailWithMapCell(discription: selectDiary!, player: videoArray[selectIndex!].video.player!)
            delegateWithMapCell?.toDetailWithMapCell(discription: selectDiary!, player: selectVideo.player!)
            
        }
    }
    func setData(){
        //ピンがあれば,まずすべて取り除く
        mapView.removeAnnotations(mapView.annotations)
       
        for i in 0..<descriptionList!.count{
            let annotation = MKPointAnnotation()
            
            if descriptionList![i].location != nil{
                annotation.coordinate = CLLocationCoordinate2DMake(descriptionList![i].location!.latitude,descriptionList![i].location!.longitude)
//                annotation.title = descriptionList![i].created.covertString()
                annotation.subtitle = descriptionList![i].text + descriptionList![i].created.covertString()
                self.mapView.addAnnotation(annotation)
            }
        }
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
        let aaa = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        var region = mapView.region
        region.center = aaa
        region.span.latitudeDelta = 180
        region.span.longitudeDelta = 180
        mapView.setRegion(region, animated:true)
        
    }
}

class baseView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){}
}
