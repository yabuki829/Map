//
//  SubscriptionViewController.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/07/06.
//
//
//import Foundation
//import UIKit
//import SwiftUI
//import Lottie
//class SubscriptionViewController : UIViewController{
//    var animationView: AnimationView = {
//        var view = AnimationView()
//        view = AnimationView(name:"earth")
//        view.backgroundColor = .clear
//        view.isUserInteractionEnabled = true
//        view.contentMode = .scaleAspectFit
//        view.loopMode = .loop
//        view.play()
//        return view
//    }()
//    let dividerView1:UIView = {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//        return view
//    }()
//    let dividerView2:UIView = {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//        return view
//    }()
//    let dividerView3:UIView = {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//        return view
//    }()
//
//    let stackView:UIStackView = {
//        let sv = UIStackView()
//        sv.axis = .vertical
//        return sv
//    }()
//    let subscriptionButton:UIButton = {
//        let button = UIButton()
//            button.setTitle("1ヶ月サブスクリプション", for: .normal)
//            button.setTitleColor(.white, for: .normal)
//            button.setTitleColor(.lightGray, for: .highlighted)
//            button.backgroundColor = .link
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        return button
//    }()
//    let priceLabel:UILabel = {
//        let label = UILabel()
//        label.text = "1ヶ月250円でご利用いただけます"
//        label.textAlignment = .center
//        label.textColor = .darkGray
//        label.font =  UIFont.systemFont(ofSize: 12)
//        return label
//    }()
//    let privacyButton:UIButton = {
//        let button = UIButton()
//            button.setTitle("プライバシーポリシー", for: .normal)
//            button.setTitleColor(.white, for: .normal)
//            button.setTitleColor(.lightGray, for: .highlighted)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        return button
//    }()
//
//    let termButton:UIButton = {
//        let button = UIButton()
//            button.setTitle("利用規約", for: .normal)
//            button.setTitleColor(.white, for: .normal)
//            button.setTitleColor(.lightGray, for: .highlighted)
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        return button
//    }()
//
//    let privacyPolicyTextView:UITextView = {
//        let label = UITextView()
//        label.text =
//        " \n 1.お支払いはご利用のAppleIDに請求されます。\n \n 2.サブスクリプション期間が終了する24時間前に解約しない限り自動継続になります。"
//        label.backgroundColor = .clear
//        label.isEditable = false
//        return label
//    }()
//
//    let backgroundImage:UIImageView = {
//        let imageview = UIImageView()
//        imageview.image = UIImage(named: "background")
//        return imageview
//    }()
//    override func viewDidLoad() {
//        addConstraint()
//        self.title  = "1ヶ月サブスクリプション"
//        SubscribeManager.shared.setup { result in
//            if result{
//                self.subscriptionButton.setTitle("ご登録済みです", for: .normal)
//                self.subscriptionButton.isEnabled = false
//            }
//        }
//    }
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//     }
//    override var shouldAutorotate: Bool {
//        return true
//    }
//    func addConstraint(){
//        view.addSubview(backgroundImage)
//        view.addSubview(animationView)
//        view.addSubview(dividerView1)
//        view.addSubview(stackView)
//        view.addSubview(dividerView2)
//        view.addSubview(subscriptionButton)
//        view.addSubview(priceLabel)
//        view.addSubview(dividerView3)
//        view.addSubview(privacyPolicyTextView)
//        view.addSubview(termButton)
//        view.addSubview(privacyButton)
//        backgroundImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
//                              left: view.leftAnchor, paddingLeft: 0,
//                              right: view.rightAnchor, paddingRight: 0,
//                              bottom: view.bottomAnchor, paddingBottom: 0)
//        animationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20,
//                             left: view.leftAnchor,paddingLeft: view.frame.width / 2 - view.frame.width / 4,
//                             width:  view.frame.width / 2,
//                             height:  view.frame.width / 2)
//
//
//        stackView.anchor(top:dividerView1.bottomAnchor, paddingTop: 30,
//                         left: view.leftAnchor, paddingLeft: 20,
//                         right: view.rightAnchor, paddingRight: 30)
//
//
//        subscriptionButton.anchor(top: stackView.bottomAnchor, paddingTop: 10,
//                                  width: view.frame.width / 2, height: 30)
//        subscriptionButton.centerX(inView: view)
//        priceLabel.anchor(top: subscriptionButton.bottomAnchor, paddingTop: 5,
//                          left: view.leftAnchor, paddingLeft: 20,
//                          right: view.rightAnchor, paddingRight: 20)
//
//
//        privacyPolicyTextView.anchor(top: dividerView3.bottomAnchor, paddingTop: 20,
//                                     left: view.leftAnchor, paddingLeft: 5,
//                                     right: view.rightAnchor, paddingRight: 5)
//        let stackViewA = UIStackView()
//        view.addSubview(stackViewA)
//        stackViewA.addArrangedSubview(termButton)
//        stackViewA.addArrangedSubview(privacyButton)
//        stackViewA.anchor(top: privacyPolicyTextView.bottomAnchor, paddingTop: 5,
//                         left:view.safeAreaLayoutGuide.leftAnchor, paddingLeft: view.frame.width / 6,
//                         right: view.safeAreaLayoutGuide.rightAnchor, paddingRight: view.frame.width / 6,
//                         bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0, height: 30)
//
//        dividerView1.anchor(top:animationView.bottomAnchor, paddingTop: 10,
//                            left: view.leftAnchor, paddingLeft: 20,
//                            right: view.rightAnchor, paddingRight: 20,
//                            height:  0.5)
//
//
//        dividerView3.anchor(top: priceLabel.bottomAnchor, paddingTop: 30,
//                                     left: view.leftAnchor, paddingLeft: 20,
//                                     right: view.rightAnchor, paddingRight: 20,
//                            height:  0.5)
//        let label1 = UILabel()
//        label1.text = "1. 投稿の制限が15件から無制限に"
//        label1.font = UIFont.boldSystemFont(ofSize: 15)
//        stackView.addArrangedSubview(label1)
//
//        let label2 = UILabel()
//        label2.text = "2. 友達数の制限が10人から無制限に"
//        label2.font = UIFont.boldSystemFont(ofSize: 15)
//        stackView.addArrangedSubview(label2)
//
//        let label3 = UILabel()
//        label3.font = UIFont.boldSystemFont(ofSize: 15)
//        label3.text = "3. 広告が非表示に"
//        stackView.addArrangedSubview(label3)
//        subscriptionButton.addTarget(self, action: #selector(subscribe(sender:)), for: .touchUpInside)
//        privacyButton.addTarget(self, action: #selector(privacy(sender:)), for: .touchUpInside)
//        termButton.addTarget(self, action: #selector(term(sender:)), for: .touchUpInside)
//    }
//    @objc func term (sender: UIButton){
//        let nav = PrivacyPolicyViewController()
//        self.present(nav, animated: true, completion: nil)
//
//    }
//    @objc  func privacy (sender: UIButton){
//        let nav = TermofPolicyViewController()
//        self.present(nav, animated: true, completion: nil)
//    }
//    @objc  func subscribe (sender: UIButton){
//        print("subscrive")
//        SubscribeManager.shared.fetchPackage { package in
//            SubscribeManager.shared.purchase(package: package)
//        }
//    }
//
//}
//import MapKit
//
//class MapBackgroundView: UIView {
//    let mapView = MKMapView()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        mapView.mapType = .hybridFlyover
//        self.backgroundColor = .black
//        addSubview(mapView)
//        mapView.anchor(top: self.topAnchor, paddingTop: 0,
//                       left: self.leftAnchor, paddingLeft: 0,
//                       right: self.rightAnchor, paddingRight: 0,
//                       bottom: self.bottomAnchor, paddingBottom: 0)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
