//
//  PostViewCell.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/25.
//

import Foundation
import UIKit
import CoreLocation
import Photos
import PKHUD
import AVFoundation

class postViewCell:BaseTableViewCell ,CLLocationManagerDelegate,UITextViewDelegate{
    var placeholderLabel : UILabel!
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    var location:Location?
    var isLocation = false
    var textViewHeight: NSLayoutConstraint!
    var friendListView: FriendListView =  {
        let view = FriendListView()
        view.isHidden = true
        return view
    }()
    let locationButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("位置情報を追加", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left

        return button
    }()
    let openFriendListButton:UIButton = {
        let button = UIButton()
        button.setTitle("公開範囲 ▼", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.contentHorizontalAlignment = .center
        button.tintColor = .lightGray
        
        return button
    }()
    
 
    let textView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func setupViews() {
        addConstraint()
        textView.delegate = self
    }
    func addConstraint(){
        settingTextViewPlaceHolder()
       
        contentView.addSubview(textView)
        contentView.addSubview(openFriendListButton)
        contentView.addSubview(locationButton)
        contentView.addSubview(friendListView)
        friendListView.anchor(top: contentView.topAnchor, paddingTop: 0,
                              left:contentView.leftAnchor, paddingLeft: 0,
                              right: contentView.rightAnchor,paddingRight: 0,
                              bottom: contentView.bottomAnchor,paddingBottom: 0)
        
        locationButton.anchor(top: contentView.topAnchor, paddingTop: 10,
                              left:contentView.leftAnchor, paddingLeft: 0,
                              right:openFriendListButton.leftAnchor,paddingRight: 0,
                              width: 120, height: 20)


        openFriendListButton.anchor(top: contentView.topAnchor, paddingTop: 10,
                                    right: contentView.rightAnchor, paddingRight: 10,
                                    width: 100, height: 20)

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0).isActive = true
        
        textViewHeight = NSLayoutConstraint.init(item: textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        textViewHeight?.isActive = true
        
        locationButton.addTarget(self, action: #selector(locationView(sender:)), for: .touchDown)
        openFriendListButton.addTarget(self, action: #selector(tapfriend(sender:)), for: .touchDown)
        
    }
    @objc func tapfriend(sender:UIButton){
        print("fiend")
        delegate?.toFriendList()
    }
    
    @objc func locationView(sender:UIButton){
        delegate?.toSelectLocation()
    }
    
    func settingTextViewPlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "出来事を記録しましょう"
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 15, y: 20)
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        textView.becomeFirstResponder()
      
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
                let subLocality = placemark.subLocality
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
                    let text = "\(String(country + Area + locality! + subLocality!))"
                    locationButton.setTitle(text,for:.normal)
                }
                else{
                    let text = "\(String(country + locality! + subLocality!))"
                    locationButton.setTitle(text,for:.normal)
                }
                locationButton.setTitleColor(.link, for: .normal)
                isLocation = true
         
            }
        }
    }
    fileprivate var currentTextViewHeight: CGFloat = 40
    func textViewDidChange(_ textView: UITextView) {
        
        //文字数が80になったら入力禁止
            self.textView.sizeToFit()
            self.textView.isScrollEnabled = false
            let resizedHeight = self.textView.frame.size.height
            self.textViewHeight.constant = resizedHeight
        
            if resizedHeight > currentTextViewHeight {
                let addingHeight = resizedHeight - currentTextViewHeight
                self.textViewHeight.constant += addingHeight
                currentTextViewHeight = resizedHeight
            }
        placeholderLabel.isHidden = !textView.text.isEmpty
        let count = textView.text.count
        //menubar のカウントを変更する
        delegate?.textfieldDidChange(count: count,reload:true)
    }
    weak var delegate:postCellDelegate? = nil
    
}


protocol postCellDelegate: AnyObject  {
    func textfieldDidChange(count:Int,reload:Bool)
    func toSelectLocation()
    func toFriendList()
}

