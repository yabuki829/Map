
import UIKit
import MapKit
import CoreLocation
import Photos
import PKHUD

class MenuView:UIView{
    let mapSateliteButton: UIButton = {
        let button = UIButton()
        button.setTitle("衛生写真", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    let mapNomalButton: UIButton = {
        let button = UIButton()
        button.setTitle("デフォルト", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

  
    func setupViews(){
        addSubview(mapSateliteButton)
        addSubview(mapNomalButton)
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        mapNomalButton.anchor(top: topAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight: 20)
        mapSateliteButton.anchor(top: mapNomalButton.bottomAnchor, paddingTop: 10,
                              left: leftAnchor, paddingLeft: 20,
                              right: rightAnchor, paddingRight:20,
                              bottom: bottomAnchor,paddingBottom: 10)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MapViewController: UIViewController {
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
    var array = [Discription]()
    var selectDiary:Discription?
    var selectImage = UIImage()
    var isOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white

    
        view.addSubview(mapView)
        view.addSubview(postButton)
        view.addSubview(menuButton)
        view.addSubview(menuView)
        addConstraintMapView()
        addConstraintButton()
        menuButton.addTarget(self, action: #selector(changeMap(sender:)), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(sendtoPostView(sender:)), for: .touchUpInside)
        
        menuView.mapNomalButton.addTarget(self, action: #selector(toDefalutsMap(sender:)), for: .touchUpInside)
        menuView.mapSateliteButton.addTarget(self, action: #selector(toSateliteMap(sender:)), for: .touchUpInside)
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
        let vc = detailViewController()
        vc.discription = selectDiary!
        vc.discriptionImage = selectImage
        navigationController?.pushViewController(vc, animated: true)
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
        
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 2,
                          right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 2)
        
        menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                        right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0)
        
    }
    
    func focusMyLocation(){
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        
    }
    
    func setData(){
        HUD.show(.progress)
        FirebaseManager.shered.getFriendDiscription { [self] (data) in
            array = DataManager.shere.get()
            array.append(contentsOf: data)
            mapView.removeAnnotations(mapView.annotations)
            for i in 0..<array.count{
                print(i,"ばんめ",array[i].title)
                let annotation = MKPointAnnotation()
                if array[i].location != nil{
                    annotation.coordinate = CLLocationCoordinate2DMake(array[i].location!.latitude,array[i].location!.longitude)
                    annotation.title = array[i].title
                    
                    annotation.subtitle = array[i].text
                    self.mapView.addAnnotation(annotation)
                }
            }
            HUD.hide()
        }
       
    }

    func setupNavigationItems(){
        
        let titleLabel = UILabel(frame: CGRect(x: 30, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.font = UIFont(name: "AlNile-Bold", size: 20)
        titleLabel.text = "PhotoShare"
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
        
        outLoop: for i in 0..<array.count{
            if annotation.title == array[i].title && annotation.subtitle == array[i].text{
                if array[i].userid == FirebaseManager.shered.getMyUserid(){
                    pinView.pinTintColor = .link
                }
                
                let stackview = setStackView()
                let textLabel = UILabel()
                let imageView = UIImageView()
                let tapStackView = UITapGestureRecognizer(target: self, action: #selector(sendtoDetailView(sender:)))
                stackview.isUserInteractionEnabled = true
                stackview.addGestureRecognizer(tapStackView)
                imageView.loadImageUsingUrlString(urlString: array[i].image.imageUrl) { [self] image in
                    if  image != nil {
                        print("aaaaaa")
                        selectImage = image!
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
                          
                            let gcd = MathManager.shered.getGreatestCommonDivisor(Int((image?.size.width)!), Int((image?.size.height)!))
                            let ration = MathManager.shered.calcAspectRation(Double(image!.size.width) ,Double(image!.size.height) , gcd: gcd)
                            let times = MathManager.shered.howmanyTimes(aspectRation: ration)
                            let width = self.view.frame.width / 3 * 2
                            imageView.anchor(height: width * times)
                            
                            let widthConstraint = NSLayoutConstraint(item: stackview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.width / 3 * 2)
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
  
}
