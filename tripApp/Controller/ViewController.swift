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
    var selectDiary:Diary?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "マップアプリ"
        mapView.delegate = self
      
        view.addSubview(mapView)
        view.addSubview(postButton)
        addConstraintMapView()
        addConstraintButton()
        
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
    @objc internal func sendtoDetailView(sender: UIButton) {
        let vc = DetailViewController()

        vc.diary = selectDiary!
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
//        let vc = DetailViewController()
//        vc.diary = selectDiary!
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        
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
        print("setData")
        array = DataManager.shere.get()
        mapView.removeAnnotations(mapView.annotations)
        for i in 0..<array.count{
            print(i,"回目")
            let annotation = MKPointAnnotation()
            if array[i].location != nil{
                annotation.coordinate = CLLocationCoordinate2DMake(array[i].location!.latitude,array[i].location!.longitude)
                annotation.title = array[i].title
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
        
              
              
              let accountImage = UIImage(systemName: "gearshape")
             
              let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(tapSettingIcon))
              
              navigationItem.rightBarButtonItems = [accountItem]
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for i in 0..<array.count{
            if view.annotation?.title == array[i].title && view.annotation?.subtitle == array[i].text{
                selectDiary = array[i]
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
        
        for i in 0..<array.count{
            if annotation.title == array[i].title && annotation.subtitle == array[i].text{
                let stackview = setStackView()
                let textLabel = UILabel()
                let imageView = UIImageView(image: UIImage(data:array[i].image))
                let button = UIButton()
                textLabel.text = array[i].text
                button.setTitle("＞＞", for: .normal)
                button.setTitleColor(.darkGray, for: .normal)
                button.setTitleColor(.systemGray3, for: .highlighted)
                button.contentHorizontalAlignment = .right
                button.addTarget(self, action: #selector(sendtoDetailView(sender:)), for: .touchUpInside)
               
                stackview.addArrangedSubview(imageView)
                stackview.addArrangedSubview(textLabel)
                stackview.addArrangedSubview(button)
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
