//
//  MapCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/30.
//

import Foundation
import UIKit
import MapKit

//画像を探すためのやつ
struct uiimageData {
    var postId:String
    var image :UIImage
}

class MapCell: BaseCell,MKMapViewDelegate,CLLocationManagerDelegate{
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

    var ImageDataArray = [uiimageData]()
    var selectImage = UIImage()
    
    var mapView =  MKMapView()
    var selectDiary:Discription?
    var isOpen = false
    var viewWidth = CGFloat()
    override func setupViews() {
        backgroundColor = .black
        mapView.delegate = self
        contentView.addSubview(mapView)
        contentView.addSubview(menuButton)
        contentView.addSubview(menuView)
        addConstraint()
        menuButton.addTarget(self, action: #selector(changeMap(sender:)), for: .touchUpInside)
        menuView.mapNomalButton.addTarget(self, action: #selector(toDefalutsMap(sender:)), for: .touchUpInside)
        menuView.mapSateliteButton.addTarget(self, action: #selector(toSateliteMap(sender:)), for: .touchUpInside)
        
    }

    func addConstraint(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
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
            if view.annotation?.title == descriptionList![i].text
                && view.annotation?.subtitle == descriptionList![i].created.toString(){
                selectDiary = descriptionList![i]
//                if mapView.region.span.latitudeDelta > 0.0015 {
                    
                    let pinToZoomOn = view.annotation
                    let aa = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)! + 0.0065, longitude: (view.annotation?.coordinate.longitude)! )
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: aa, span: span)
                    mapView.setRegion(region, animated: true)
                    
//                }
                
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
        print(annotation.title,"を探します")
        if annotation.title == descriptionList![i].text &&
            annotation.subtitle == descriptionList![i].created.toString(){
            let stackview = setStackView()
            let imageView = UIImageView()
            let tapStackView = UITapGestureRecognizer(target: self, action: #selector(sendtoDetailView(sender:)))
            stackview.isUserInteractionEnabled = true
            stackview.addGestureRecognizer(tapStackView)
            
            
            imageView.setImage(urlString: descriptionList![i].image.imageUrl) { [self] image in
                
                if  image != nil {
                    print("画像準備完了")
                    
                    let button = UIButton()
                        button.setTitle("＞＞", for: .normal)
                        button.setTitleColor(.darkGray, for: .normal)
                        button.setTitleColor(.systemGray3, for: .highlighted)
                        button.contentHorizontalAlignment = .right
                        button.addTarget(self, action: #selector(sendtoDetailView(sender:)), for: .touchUpInside)
                
                        stackview.addArrangedSubview(imageView)
//                        stackview.addArrangedSubview(textLabel)
                        stackview.addArrangedSubview(button)
                        stackview.translatesAutoresizingMaskIntoConstraints = false
                      
                        let gcd = MathManager.shered.getGreatestCommonDivisor(Int((image?.size.width)!), Int((image?.size.height)!))
                        let ration = MathManager.shered.calcAspectRation(Double(image!.size.width) ,Double(image!.size.height) , gcd: gcd)
                        let times = MathManager.shered.howmanyTimes(aspectRation: ration)
                        let width = viewWidth / 3 * 2
                  
                        imageView.anchor(height: width * times)
                        
                    let widthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewWidth / 3 * 2)
                           stackview.addConstraint(widthConstraint)
                        
                        pinView.detailCalloutAccessoryView = stackview
                    
                        
                    }
                else{
                    print("画像エラー")
                }
            
                }
         
            }
        else{
            print("違います",descriptionList![i].text)
        }
            
        
        }
        return pinView
    }
    
    
    func setStackView() -> UIStackView{
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .fill
        return stackview
    }
    @objc internal func sendtoDetailView(sender: UIButton) {
       
        if selectDiary != nil{
            print("aaaaaaaa")
            delegateWithMapCell?.toDetailWithMapCell(discription: selectDiary!)
        }
        else{
            print("画像が入ってない")
        }
    }
    func setData(){
        print(descriptionList?.count,"回回します")
        for i in 0..<descriptionList!.count{
            let annotation = MKPointAnnotation()
            
            if descriptionList![i].location != nil{
                print(i,descriptionList![i].text,descriptionList![i].location)
                annotation.coordinate = CLLocationCoordinate2DMake(descriptionList![i].location!.latitude,descriptionList![i].location!.longitude)
                annotation.title = descriptionList![i].text
                
                annotation.subtitle = descriptionList![i].created.toString()
                self.mapView.addAnnotation(annotation)
            }
        }
    }

   
}

protocol mapCellDelegate: class  {
    func toDetailWithMapCell(discription:Discription)
}
