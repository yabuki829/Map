//
//  ImageDetailView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation
import UIKit


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
        view.addSubview(imageView)
        addConstraint()
        settingNav()
    }
    func addConstraint(){
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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


