//
//  extension.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation
import UIKit
import CoreLocation
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
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyy年MM月dd日(eee) HH:mm"
        let date = formatter.string(from: self )
        return date
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
