//
//  MapCell.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/30.
//

import Foundation
import UIKit
import MapKit

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
    
    var descriptionList = [Discription]()
    var selectImage = UIImage()
    var mapView =  MKMapView()
    var selectDiary:Discription?
    var isOpen = false
    var viewWidth = CGFloat()
    override func setupViews() {
        backgroundColor = .black
        mapView.delegate = self
        addSubview(mapView)
        addSubview(menuButton)
        addSubview(menuView)
        addConstraint()
        getData()
        
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
   
    func getData(){
        print("取得します")
        FirebaseManager.shered.getDiscription(userid:FirebaseManager.shered.getMyUserid() ) { (result) in
            print("完了",result.count)
            self.descriptionList = DataManager.shere.get()
            self.setData()
        }   
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for i in 0..<descriptionList.count{
            if view.annotation?.title == descriptionList[i].title && view.annotation?.subtitle == descriptionList[i].text{
                selectDiary = descriptionList[i]
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
        
    outLoop: for i in 0..<descriptionList.count{
        if annotation.title == descriptionList[i].title && annotation.subtitle == descriptionList[i].text{
            if descriptionList[i].userid == FirebaseManager.shered.getMyUserid(){
                pinView.pinTintColor = .link
            }
            
            let stackview = setStackView()
            let textLabel = UILabel()
            let imageView = UIImageView()
            let tapStackView = UITapGestureRecognizer(target: self, action: #selector(sendtoDetailView(sender:)))
            stackview.isUserInteractionEnabled = true
            stackview.addGestureRecognizer(tapStackView)
            imageView.loadImageUsingUrlString(urlString: descriptionList[i].image.imageUrl) { [self] image in
                if  image != nil {
                    
                    selectImage = image!
                    let button = UIButton()
                        textLabel.text = descriptionList[i].text
                        textLabel.numberOfLines = 3
                        button.setTitle("＞＞", for: .normal)
                        button.setTitleColor(.darkGray, for: .normal)
                        button.setTitleColor(.systemGray3, for: .highlighted)
                        button.contentHorizontalAlignment = .right
                        button.addTarget(self, action: #selector(sendtoDetailView(sender:)), for: .touchUpInside)
                
                        stackview.addArrangedSubview(imageView)
                        stackview.addArrangedSubview(textLabel)
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
            
            }
            
            break outLoop
            
         
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
        print("aaaaaaaa")
        if selectDiary != nil{
            print("tap")
            delegateWithMapCell?.toDetailWithMapCell(discription: selectDiary!, selectImage: selectImage)
        }
    }
    func setData(){
        for i in 0..<descriptionList.count{
            print(i,"ばんめ",descriptionList[i].title)
            let annotation = MKPointAnnotation()
            if descriptionList[i].location != nil{
                annotation.coordinate = CLLocationCoordinate2DMake(descriptionList[i].location!.latitude,descriptionList[i].location!.longitude)
                annotation.title = descriptionList[i].title
                
                annotation.subtitle = descriptionList[i].text
                self.mapView.addAnnotation(annotation)
            }
        }
    }

   
}

protocol mapCellDelegate: class  {
    func toDetailWithMapCell(discription:Discription,selectImage:UIImage)
}
