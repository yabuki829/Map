//
//  ImageDetailView.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation
import UIKit
import SwiftUI


class ImageDetailViewContriller:UIViewController,UIScrollViewDelegate{
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let scrollView = UIScrollView()
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
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.backgroundColor = .black
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let gcd = MathManager.shered.getGreatestCommonDivisor(Int((image?.size.width)!), Int((image?.size.height)!))
        let ration = MathManager.shered.calcAspectRation(Double(image!.size.width) ,Double(image!.size.height) , gcd: gcd)
        let times = MathManager.shered.howmanyTimes(aspectRation: ration)
        
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 83
        let height = view.frame.height - statusBarHeight - navigationBarHeight - tabbarHeight
        
        print(statusBarHeight)
        let toppadding = (height - view.frame.width * times)  / 2
        
        imageView.anchor(top: scrollView.topAnchor, paddingTop: toppadding,
                         left: scrollView.leftAnchor, paddingLeft: 0,
                         right: scrollView.rightAnchor, paddingRight: 0,
                         bottom: scrollView.bottomAnchor, paddingBottom: 0, width: view.frame.width, height: view.frame.width * times)
       
        
        
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
    func viewForZooming(in sclool:UIScrollView) -> UIView? {
           return imageView

    }
}


