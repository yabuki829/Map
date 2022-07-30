//
//  AdCell.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/28.
//

import Foundation
import UIKit
import NendAd

class AdCell:BaseCell, NADNativeDelegate{

    
    
    private var client = NADNativeClient(spotID:485504, apiKey: "30fda4b3386e793a14b27bedb4dcd29f03d638e5")
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleToFill

        return imageView
    }()
    let prelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        return label
    }()
 
    override func setupViews() {
        addAD()
        print("呼ばれてます")
        addConstraint()
        
    }
    func addConstraint(){
        self.addSubview(prelabel)
        self.addSubview(logoImageView)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        logoImageView.anchor(top: self.topAnchor, paddingTop: 10,
                             left: leftAnchor, paddingLeft: 10,width: 50,height: 50)
        logoImageView.layer.cornerRadius = 25
        logoImageView.clipsToBounds = true
        
        titleLabel.anchor(top: topAnchor, paddingTop: 10,
                          left: logoImageView.rightAnchor, paddingLeft: 10,
                          bottom: imageView.topAnchor,paddingBottom: 5)
        
        prelabel.anchor(top: topAnchor, paddingTop: 20,
                        left: titleLabel.rightAnchor, paddingLeft: 0,
                        right: rightAnchor, paddingRight: 10)
        
        imageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 5,
                         left: logoImageView.rightAnchor, paddingLeft: 0,
                         right: rightAnchor, paddingRight: 10,
                         bottom: bottomAnchor,paddingBottom: 10,
                         width: self.frame.width - 70,height: self.frame.width - 70)
        
    }
    func addAD(){
//        self.client = NADNativeClient(spotID:1063089, apiKey: "78816baf1953dcb7c0d02fe4554649a0e3b06913")
//        self.client =
        self.client!.load() { (ad, error) in
            if let nativeAd = ad {
                // 成功
                nativeAd.delegate = self
                nativeAd.intoView(self, advertisingExplicitly: .AD)
                print("成功")
            } else {
                // 失敗
                print("error:\(error!)")
            }
        }
    
    }
     
}


extension AdCell :NADNativeViewRendering{
    func prTextLabel() -> UILabel! {
        print("1")
        return self.prelabel
    }

    func promotionNameLabel() -> UILabel! {
        print("2")
        return self.titleLabel
    }

    func adImageView() -> UIImageView! {
        print("3")
        return self.imageView
    }

    func nadLogoImageView() -> UIImageView! {
        print("4")
        return self.logoImageView
    }
}

//
//
//class AdCell:BaseCell{
//
//    var nadView = NADView()
//    var adLabel = UILabel()
//
//    override func setupViews() {
//
//        nadView.delegate = self
//        addAD()
//        self.addSubview(nadView)
//        self.addSubview(adLabel)
//        nadView.anchor(top: self.topAnchor, paddingTop: 25,
//                       right: self.rightAnchor,paddingRight: 10,
//                       bottom: self.bottomAnchor, paddingBottom:25,
//                       width: 320, height: 250)
//        adLabel.anchor(top: self.topAnchor, paddingTop: 25,
//                       left: self.leftAnchor, paddingLeft: 10,
//                       width: 40,height:  40)
//        adLabel.text = "Ad"
//        adLabel.backgroundColor = .black
//        adLabel.textAlignment = .center
//        adLabel.textColor = .white
//        adLabel.layer.cornerRadius = 20
//        adLabel.clipsToBounds = true
//        adLabel.isHidden = true
//    }
//
//    func addAD(){
//        nadView.setNendID(70356, apiKey: "88d88a288fdea5c01d17ea8e494168e834860fd6")
//
//        //320 250
////        nadView.setNendID(1061511, apiKey: "89991d46217936f91cb687ea5dcb2edf74576f11")
//
//
//        nadView.load()
//    }
//
//}
//
//
//extension AdCell :NADViewDelegate{
//    func nadViewDidFinishLoad(_ adView: NADView!) {
//        print("ロード完了")
//        adLabel.isHidden = false
//    }
//    func nadViewDidReceiveAd(_ adView: NADView!){
//        print("受信をしました")
//    }
//    func nadViewDidFail(toReceiveAd adView: NADView!) {
//
//           // エラーごとに処理を分岐する場合
//           let error: NSError = adView.error as NSError
//                print(error)
//           switch (error.code) {
//           case NADViewErrorCode.NADVIEW_AD_SIZE_TOO_LARGE.rawValue:
//               print("広告サイズがディスプレイサイズよりも大きい")
//               break
//           case NADViewErrorCode.NADVIEW_INVALID_RESPONSE_TYPE.rawValue:
//               print(" 不明な広告ビュータイプ")
//               break
//           case NADViewErrorCode.NADVIEW_FAILED_AD_REQUEST.rawValue:
//               print("広告取得失敗")
//               break
//           case NADViewErrorCode.NADVIEW_FAILED_AD_DOWNLOAD.rawValue:
//               print(" 広告画像の取得失敗")
//               break
//           case NADViewErrorCode.NADVIEW_AD_SIZE_DIFFERENCES.rawValue:
//               print(" リクエストしたサイズと取得したサイズが異なる")
//               break
//           default:
//               print("その他")
//               break
//           }
//       }
//}
