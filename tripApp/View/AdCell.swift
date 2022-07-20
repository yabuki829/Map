//
//  AdCell.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/28.
//

import Foundation
import UIKit
import NendAd

class AdCell:BaseCell{
    
    var nadView = NADView()
    var adLabel = UILabel()
    
    override func setupViews() {
        
        nadView.delegate = self
        addAD()
        self.addSubview(nadView)
        self.addSubview(adLabel)
        nadView.anchor(top: self.topAnchor, paddingTop: 45,
                       right: self.rightAnchor,paddingRight: 10,
                       bottom: self.bottomAnchor, paddingBottom:10,
                       width: 320, height: 250)
        adLabel.anchor(top: self.topAnchor, paddingTop: 5,
                       left: self.leftAnchor, paddingLeft: 10,
                       width: 40,height:  40)
        adLabel.text = "Ad"
        adLabel.backgroundColor = .black
        adLabel.textAlignment = .center
        adLabel.textColor = .white
        adLabel.layer.cornerRadius = 20
        adLabel.clipsToBounds = true
    }

    func addAD(){
        nadView.setNendID(70356, apiKey: "88d88a288fdea5c01d17ea8e494168e834860fd6")
        
        //320 250
//        nadView.setNendID(1061511, apiKey: "89991d46217936f91cb687ea5dcb2edf74576f11")
            
      
        nadView.load()
    }
     
}


extension AdCell :NADViewDelegate{
    func nadViewDidFinishLoad(_ adView: NADView!) {
        print("ロード完了")
    }
    func nadViewDidReceiveAd(_ adView: NADView!){
        print("受信をしました")
    }
    func nadViewDidFail(toReceiveAd adView: NADView!) {
           
           // エラーごとに処理を分岐する場合
           let error: NSError = adView.error as NSError
print(error)
           switch (error.code) {
           case NADViewErrorCode.NADVIEW_AD_SIZE_TOO_LARGE.rawValue:
               print("広告サイズがディスプレイサイズよりも大きい")
               break
           case NADViewErrorCode.NADVIEW_INVALID_RESPONSE_TYPE.rawValue:
               print(" 不明な広告ビュータイプ")
               break
           case NADViewErrorCode.NADVIEW_FAILED_AD_REQUEST.rawValue:
               print("広告取得失敗")
               break
           case NADViewErrorCode.NADVIEW_FAILED_AD_DOWNLOAD.rawValue:
               print(" 広告画像の取得失敗")
               break
           case NADViewErrorCode.NADVIEW_AD_SIZE_DIFFERENCES.rawValue:
               print(" リクエストしたサイズと取得したサイズが異なる")
               break
           default:
               print("その他")
               break
           }
       }
}
