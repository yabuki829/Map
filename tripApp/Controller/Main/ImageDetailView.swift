//
//  ImageDetailView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation
import UIKit
import SwiftUI


class ImageDetailViewContriller:UIViewController{
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var image:UIImage? {
        didSet{
            imageView.image = image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addConstraint()
        settingNav()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    override var shouldAutorotate: Bool {
        return true
    }
    func addConstraint(){

        view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                         left: view.safeAreaLayoutGuide.leftAnchor, paddingLeft: 0,
                         right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: 0,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        
        imageView.contentMode = .scaleAspectFit
        
        
    }
    func settingNav(){
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
        backItem.tintColor = .darkGray
        let saveImageButton = UIImage(systemName: "square.and.arrow.down")
        let saveImageItem =  UIBarButtonItem(image: saveImageButton, style: .plain, target: self, action: #selector(saveImage(sender:)))
        saveImageItem.tintColor = .darkGray
        
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = saveImageItem
    }
    @objc func back(sender : UIButton){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func saveImage(sender : UIButton){
        let targetImage = imageView.image
               UIImageWriteToSavedPhotosAlbum(targetImage!,self,#selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {

        var title = "保存完了"
        var message = "カメラロールに保存しました"
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
         }
  
}

