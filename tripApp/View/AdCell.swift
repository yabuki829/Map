////
////  AdCell.swift
////  tripApp
////
////  Created by yabuki shodai on 2022/06/28.
////
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
        self.client = NADNativeClient(spotID:1063089, apiKey: "78816baf1953dcb7c0d02fe4554649a0e3b06913")
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
