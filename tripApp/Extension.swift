//
//  extension.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

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
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyy年MM月dd日(eee) HH:mm"
        let date = formatter.string(from: self )
        return date
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

extension UIImageView{
    
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
        
        Nuke.loadImage(with: url, options: option,into: self)
        compleation(self.image)
        
    }
    
//    func loadImageUsingUrlString(urlString:String){
//        image = nil
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//            
//        let task = URLSession.shared.dataTask(with: url!) {  (data, response, error) in
//            if error != nil{
//                return
//            }
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)
//            }
//          
//        }
//        task.resume()
//    }
//    func loadImageUsingUrlString(urlString:String,compleation:@escaping (UIImage?) -> Void){
//        image = nil
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.httpMethod = "GET"
//
//        let task = URLSession.shared.dataTask(with: url!) {  (data, response, error) in
//            if error != nil{
//                compleation(nil)
//                return
//            }
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)
//                compleation(self.image)
//            }
//
//        }
//        task.resume()
//    }
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



enum TransitionType {
    case presentation
    case dismissal
}

class ZoomTransition: NSObject {
    let transitionDuration: Double = 0.1
    var transition: TransitionType = .presentation
}

extension ZoomTransition :UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
           return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
           switch transition {
               
           case .presentation:
                //画面遷移
               presentTransition(using: transitionContext)
           case .dismissal:
               //前の画面に戻る
               dismissalTransition(using: transitionContext)
           }
    }
    
    private func presentTransition(using transitionContext: UIViewControllerContextTransitioning) {
            // 画面遷移アニメーション
        
        let fromVC = transitionContext.viewController(forKey: .from) as! profileViewController
        let toVC = transitionContext.viewController(forKey: .to) as! detailViewController
        // トランジションコンテクストからアニメーションを描画するためのコンテナービューを取得
        let containerView = transitionContext.containerView
        
        let cell = fromVC.collectionView.cellForItem(at: (fromVC.mapAndDiscriptionCell?.discriptioncell.collectionView.indexPathsForSelectedItems?.first)! ) as! DiscriptionImageCell
        let animationView = UIImageView(image: cell.imageView.image)
        animationView.frame = containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        cell.imageView.isHidden = true
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toVC.view.layoutIfNeeded()
        toVC.cell.imageView!.isHidden = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(animationView)
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
            toVC.view.alpha = 0.0
            animationView.frame = containerView.convert(toVC.cell.imageView!.frame, from: toVC.view)
        } completion: { result in
            toVC.cell.imageView!.isHidden = false
            cell.imageView.isHidden = false
            animationView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }


        
        
    
    }

    private func dismissalTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 戻る時のアニメーション
        print("戻る")
    }
}

extension ZoomTransition: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .presentation
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition = .dismissal
        return self
    }
}

