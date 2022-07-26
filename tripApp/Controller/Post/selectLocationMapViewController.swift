//
//  selectLocationMapViewController.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/26.
//

import Foundation
import UIKit
import MapKit
import SwiftUI


class SelectLocationMapViewController :UIViewController,MKMapViewDelegate {
    let mapView = MKMapView()
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    
    var location = Location(latitude: 0, longitude: 0)
    var locationName = ""
    let locationButton :UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "paperplane.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    var centerPinImage:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "plus")
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    override func viewDidLoad() {
        settingMapView()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        view.addSubview(mapView)
        view.addSubview(centerPinImage)
        view.addSubview(locationButton)
        locationButton.addTarget(self, action: #selector(setMyLocation(sender:)), for: .touchUpInside)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                       left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                       right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        locationButton.anchor(right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 20,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom:20,
                              width: view.frame.width / 7, height: view.frame.width / 7)
        
        centerPinImage.center(inView: mapView)
        centerPinImage.anchor(width:view.frame.width / 10,height: view.frame.width / 10)
        setupNavigationItems()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
                return true
    }
    @objc internal func setMyLocation(sender: UIButton) {
        setupLocationManager()
    }
    func settingMapView(){
        let latitude = 35.681236
        let longitude = 139.767125
        // 緯度・軽度を設定
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        // マップビューに緯度・軽度を設定
    
        
        mapView.delegate = self
        var region = mapView.region
        region.center = location
        region.span.latitudeDelta = 0.05
        region.span.longitudeDelta = 0.05
        // マップビューに縮尺を設定
        mapView.setRegion(region, animated:true)
       
      
        
    }
    
 
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //ここの座標を現在地として使う
//        print(mapView.centerCoordinate)
        location = Location(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
       
    }
    
    @objc func back(sender : UIButton){
        print("Back")
        let nav = self.navigationController
        getLocationName(location: self.location) { [self] text in
            self.locationName = text
            let preVC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! PostViewController
            // 値を渡す
            preVC.postCell.location = self.location
            preVC.postCell.isLocation = true
            preVC.postCell.locationButton.setTitle(locationName, for: .normal)
            preVC.postCell.locationButton.setTitleColor(.darkGray, for: .normal)
            // popする
            self.navigationController?.popViewController(animated: true)
        }
        // 一つ前のViewControllerを取得する
       
       
    }
    func setupNavigationItems(){
        self.title = "位置情報"
        navigationController?.navigationBar.shadowImage = UIImage()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let backItem  = UIBarButtonItem(title: "追加", style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .link
        navigationItem.rightBarButtonItem = backItem
        
    }
    
}


extension SelectLocationMapViewController:CLLocationManagerDelegate{
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
        mapView.setCenter(location!.coordinate, animated: true)
        
        self.location = Location(latitude: latitude!, longitude: longitude!)
        
        getLocationName(location: self.location) { text in
            self.locationName = text
        }
       
    }
    func getLocationName(location:Location,compleation:@escaping (String) -> Void) {
        let Location = CLLocation(latitude: location.latitude, longitude:location.longitude)
        CLGeocoder().reverseGeocodeLocation(Location) { [self] placemarks, error in
            if let placemark = placemarks?.first {
                print(placemark)
                let country = placemark.country ?? ""
                let locality = placemark.locality ?? ""
                let subLocality = placemark.subLocality ?? ""
                var text = ""
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
//                    text = "\(String((country ?? "") + Area + (locality ?? "") + (subLocality ?? "")))"
                    text = country + Area + locality + subLocality
                    compleation(text)
                }
                else{
                    text = country + locality + subLocality
                    compleation(text)
                   
                }
                
              
            }
        }
    }
}
