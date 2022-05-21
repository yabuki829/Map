
import UIKit
import MapKit
import CoreLocation
import Photos
class MapViewController: UIViewController {
    let segumentView: UISegmentedControl = {
        let params = ["標準", "航空写真"]
        let segumentView = UISegmentedControl(items: params)
        segumentView.selectedSegmentIndex = 0
        segumentView.backgroundColor = .systemGray5
        segumentView.backgroundImage(for: .normal, barMetrics: .compact)
     
        return segumentView
    }()
    
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
        mapView.delegate = self
        self.navigationController?.navigationBar.barTintColor = .white

        segumentView.addTarget(self, action: #selector(changeSegument), for: UIControl.Event.valueChanged)
        segumentView.layer.cornerRadius = 0
        segumentView.clipsToBounds = true
        segumentView.layer.borderWidth = 2
        segumentView.layer.borderColor = UIColor.systemGray5.cgColor
        segumentView.layer.masksToBounds = true
        
        view.addSubview(mapView)
        view.addSubview(postButton)
        view.addSubview(segumentView)
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
        nav.modalTransitionStyle = .flipHorizontal
        self.present(nav, animated: true, completion: nil)
    }
    @objc func changeSegument(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                mapView.mapType = .standard
            case 1:
                mapView.mapType = .hybridFlyover
            default:
                break
        }
    }
    func addConstraintMapView(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func addConstraintButton(){
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:-20     ).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: view.frame.width / 7).isActive = true
        
        segumentView.translatesAutoresizingMaskIntoConstraints = false
        segumentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        segumentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 5).isActive = true
        segumentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -5).isActive = true
        
        segumentView.heightAnchor.constraint(equalToConstant:30 ).isActive = true
       
        
    }
    
    func focusMyLocation(){
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func setData(){
        array = DataManager.shere.get()
        mapView.removeAnnotations(mapView.annotations)
        for i in 0..<array.count{
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
        titleLabel.tintColor = .darkGray
        navigationItem.titleView = titleLabel
              
        let accountImage = UIImage(systemName: "text.justify")
             
        let accountItem = UIBarButtonItem(image: accountImage, style: .plain, target: self, action: #selector(tapSettingIcon))
              
        navigationItem.rightBarButtonItems = [accountItem]
        navigationController?.navigationBar.tintColor = .darkGray
    }
    @objc  func search(){
       print("Post")
     }
    @objc func tapSettingIcon(){
        let layout = UICollectionViewFlowLayout()
        let nav = UINavigationController(rootViewController: SettingViewController(collectionViewLayout: layout))
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
     }

}



extension MapViewController:MKMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        let region = MKCoordinateRegion(center: view.annotation!.coordinate, span: mapView.region.span)
//
//        mapView.setRegion(region, animated: true)
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
