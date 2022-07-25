

import Foundation
import UIKit
import CoreLocation
import CryptoKit
import Nuke
extension Encodable {

    var json: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension Decodable {

    static func decode(json data: Data?) -> Self? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}

extension UserDefaults {

    //コピペ
    //今度精読する。　https://qiita.com/yuki0n0/items/280e351f85c502945d06
    ///
    ///  setCodable ではなく set という関数名にすると、String をセットしたいときに Codable と衝突して Codable 扱いとなってしまうため注意。
    func setCodable(_ value: Codable?, forKey key: String) {
        guard let json: Any = value?.json else { return }
        self.set(json, forKey: key)
        synchronize()
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        let data = self.data(forKey: key)
        let object = T.decode(json: data)
        return object
    }
}


extension String{
    func generateID(_ length: Int) -> String {
               let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
               var randomString = ""
               for _ in 0 ..< length {
                   randomString += String(string.randomElement()!)
               }
               return randomString
       }
}


extension UIImage{
    func convert_data() -> Data{
         let  data =   self.jpegData(compressionQuality: 1)
           return data!
    }
}

extension Date{
    func covertString() -> String{
        let formatter = DateFormatter()
        let location = LanguageManager.shered.getlocation()
        if location == "ja"{
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyy年MM月dd日(eee)HH:mm"
            let date = formatter.string(from: self )
            return date
        }
        else{
            print("not ja")
            let formatter: DateFormatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = .current
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let date = formatter.string(from: self )
            print(date)
            return date
        }
      
       
    }
    
   
    func toString() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        formatter.dateFormat = "yyyMMddeeeHHmmss"
        let date = formatter.string(from: self )
        return date
    }
    
    func secondAgo() -> String  {
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour, .minute, .second], from: self, to: Date())
        
        if let year = components.year, year > 0 {
            return "\(year)年前"
        }
        if let month = components.month, month > 0 {
            return "\(month)ヶ月前"
        }
       
        if let day = components.day, day > 0 {
            return "\(day)日前"
        }
        if let hour = components.hour,hour > 0 {
          
            return "\(hour)時間前"
           
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)分前"
           
        }
        if let second = components.second, second > 0 {
            return "\(second)秒前"
           
        }
            return "たった今"
    }

}
extension String{
    func toDate() -> Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        formatter.dateFormat = "yyyMMddeeeHHmm"
        let date = formatter.date(from: self )
        return date ?? Date()
    }
}





extension Location{
    func geocoding(compleation:@escaping (String) -> Void){
        let Location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        var text = ""
        CLGeocoder().reverseGeocodeLocation(Location) {  placemarks, error in
            if let placemark = placemarks?.first {
                print(placemark)
                let country = String(placemark.country!)
                let locality = placemark.locality
                let subLocality = placemark.subLocality
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
                    text = "\(String(country + Area + locality! + subLocality!))"
                    compleation(text)
                }
                else{
                    text = "\(String(country + locality! + subLocality!))"
                   compleation(text)
                }
               
            }
        }
        
    }
}




extension UITextField {
    func setUnderLine(color:UIColor) {
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = color
        addSubview(underline)
        bringSubviewToFront(underline)
    }
}


let imageCache = NSCache<AnyObject, UIImage>()
extension AVPlayer {
    func loadVideo(urlString:String){
    }
}
extension UIImageView{
    func setimage(asset:AVAsset,compleation:@escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    self.image = UIImage(cgImage: image, scale: 0, orientation: .up)
                    compleation(true)
                }
                else {
                    compleation(false)
                }
            })
        }
    }
    func setImage(urlString:String){
        let url = URL(string: urlString)
        let option = ImageLoadingOptions(
            placeholder: UIImage(named: "画像"),
            transition: .fadeIn(duration: 0.1)
            
        )
        
        Nuke.loadImage(with: url, options: option,into: self)
        
    }
    func setImage(urlString:String,compleation:@escaping (UIImage?) -> Void){
        let url = URL(string: urlString)
        let option = ImageLoadingOptions(
            placeholder: UIImage(named: "画像"),
            transition: .fadeIn(duration: 0.1)
        )
        
        
        Nuke.loadImage(with: url, options: option, into: self) { result in
            compleation(self.image)
        }
        
    }

}


extension UIView{
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                
                left: NSLayoutXAxisAnchor? = nil,
                paddingLeft: CGFloat = 0,
                
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0,
                
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                
                width: CGFloat? = nil,
                height: CGFloat? = nil) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }

    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingleft: CGFloat? = nil, constant: CGFloat? = 0) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true

        if let leftAnchor = leftAnchor, let padding = paddingleft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }

    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomAnchor)
    }
}
import AVFoundation
import AVKit

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            imageGenerator.appliesPreferredTrackTransform = true
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image, scale: 0, orientation: .up))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

extension String {

    func sha_256() -> String {
        let data = Data(self.utf8)
        let hashedData = SHA256.hash(data: data)
        let result = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return result
    }
}
