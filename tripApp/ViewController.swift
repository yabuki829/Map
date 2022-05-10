//
//  ViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/08.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController {

    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.showsUserLocation = true
       
        return map
    }()
    var postButton:UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pencil.circle.fill")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    var locationManager:CLLocationManager!
    
    var array = [Diary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "マップアプリ"
        mapView.delegate = self
      
        view.addSubview(mapView)
        view.addSubview(postButton)
        addConstraintMapView()
        addConstraintButton()
        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        mapView.addGestureRecognizer(myLongPressGesture)
        
        postButton.addTarget(self, action: #selector(sendtoPostView(sender:)), for: .touchUpInside)
        setupNavigationItems()
        
        
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
    }
    @objc internal func sendtoPostView(sender: UIButton) {
        let nav = UINavigationController(rootViewController: PostViewController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
    @objc internal func tapGesture(sender: UILongPressGestureRecognizer){
        let location:CGPoint = sender.location(in: mapView)
                print("tap")
        if (sender.state == UIGestureRecognizer.State.ended){
                    
            let mapPoint:CLLocationCoordinate2D = mapView.convert(location, toCoordinateFrom: mapView)
                    
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
            annotation.title = "あああああ"
            annotation.subtitle = "テストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテスト"
            mapView.addAnnotation(annotation)
        }

      }

    
    func addConstraintMapView(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func addConstraintButton(){
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        postButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
   
    }
    func focusMyLocation(){
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func setData(){
        array = DataManager.shere.get()
        print(array.count)
        for i in 0..<array.count{
            let annotation = MKPointAnnotation()
            if array[i].location != nil{
                print(i + 1,"かいめ")
                print(array[i].text)
                annotation.coordinate = CLLocationCoordinate2DMake(array[i].location!.latitude,array[i].location!.longitude)
                annotation.title = array[i].date.covertString()
                annotation.subtitle = array[i].text
                self.mapView.addAnnotation(annotation)
                
            }
            
        }
    }

    
    func setupNavigationItems(){
        
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.font = UIFont(name: "AlNile-Bold", size: 20)
        titleLabel.text = "mapapp"
        navigationItem.titleView = titleLabel
        
        let searchImage = UIImage(systemName:"magnifyingglass")
              let searchItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(search))
              
              
              let accountImage = UIImage(systemName: "gearshape")
             
              let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(tapSettingIcon))
              
              navigationItem.rightBarButtonItems = [accountItem,searchItem]
              
              navigationController?.navigationBar.tintColor = .darkGray
    }
    @objc  func search(){
       print("Post")
     }
     @objc func tapSettingIcon(){
         print("tapSetting")
     }

}



extension MapViewController:MKMapViewDelegate,CLLocationManagerDelegate{

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
        
        for i in 0..<array.count{
            if annotation.title == array[i].date.covertString() && annotation.subtitle == array[i].text{
                //stackviewに変更する
                
                let stackview = setStackView()
                let textLabel = UILabel()
                let imageView = UIImageView(image: UIImage(data:array[i].image))
                textLabel.text = array[i].text
                stackview.addArrangedSubview(imageView)
                stackview.addArrangedSubview(textLabel)
                stackview.translatesAutoresizingMaskIntoConstraints = false
                let widthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width / 3 * 2)
                   stackview.addConstraint(widthConstraint)
                let heightConstraint = NSLayoutConstraint(item: stackview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width / 3 * 2)
                   stackview.addConstraint(heightConstraint)
              
                
                pinView.detailCalloutAccessoryView = stackview
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
  
}
