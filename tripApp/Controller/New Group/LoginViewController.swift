//
//  LoginViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import AuthenticationServices
import Foundation
import UIKit
import CryptoKit
import FirebaseAuth
import Lottie

class LoginViewController:UIViewController{
    var currentNonce = ""

    var animationView: AnimationView = {
        var view = AnimationView()
        view = AnimationView(name:"LoginPageAnimation")
        view.backgroundColor = .clear
        
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.loopMode = .repeat(10)
        view.play()
        return view
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Photoshare"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    let appleLoginButton = ASAuthorizationAppleIDButton()
    let orLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "- or -"
        return label
    }()
    
    @objc let checkButton:UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
//        checkmark.square
        button.tintColor = .darkGray
        return button
    }()
    let privacyPolicyButton:UIButton = {
        let button = UIButton()
        button.setTitle("PrivacyPolicy", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
  var isCheck = false
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .white
       
        view.addSubview(animationView)
        animationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.width / 4,
                             left: view.leftAnchor,paddingLeft: view.frame.width / 2 - view.frame.width / 4,
                             width: view.frame.width / 2,
                             height: view.frame.width / 2)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: animationView.bottomAnchor, paddingTop: 0,
                          left: view.leftAnchor, paddingLeft: 20,
                          right: view.rightAnchor, paddingRight: 20)
        
        view.addSubview(appleLoginButton)
        appleLoginButton.addTarget(self, action: #selector(loginWithApple), for: .touchUpInside)
        
        appleLoginButton.centerX(inView:view)
        appleLoginButton.anchor(top:titleLabel.bottomAnchor,paddingTop:120,
                                width: view.frame.width - 100, height: 50)
        
        
        view.addSubview(stackView)
        stackView.anchor(top: appleLoginButton.bottomAnchor, paddingTop: 60,
                         left: view.leftAnchor, paddingLeft: 60,
                         right: view.rightAnchor, paddingRight: 60,
                         height: 30)
        stackView.addArrangedSubview(privacyPolicyButton)
        stackView.addArrangedSubview(checkButton)
        checkButton.anchor(width:30)
        checkButton.addTarget(self, action: #selector(chack), for: .touchDown)
        privacyPolicyButton.addTarget(self, action: #selector(registerWithEmail), for: .touchDown)
    }
    

    func move(){
        let nav = MainTabBarController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    @objc func chack(){
        isCheck = !isCheck
        if isCheck {
            checkButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        else{
            checkButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
    
    
    @objc func loginWithEmail(){
        print("Email Login")
        let nav = EmailLoginViewController()
        self.present(nav, animated: true, completion: nil)
    }
    @objc func registerWithEmail(){
        print("regiser")
        let nav = RegisterWithEmailViewController()
        self.present(nav, animated: true, completion: nil)
    }
    @objc func loginWithApple(){
        print("Apple Login")
        if isCheck {
            currentNonce = randomNonceString()

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = currentNonce.sha_256()

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        else{
            //利用規約をAlert
        }
        
        
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error")
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("完了")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let appleIDToken = appleIDCredential.identityToken else {
                    debugPrint("有効なトークンが得られなかった為、処理を中断")
                    return
                }

                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    debugPrint("トークンデータの文字列化に失敗: \(appleIDToken.debugDescription)")
                    return
                }
                if currentNonce.count == 0 { fatalError("不正なNonce") }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce)

                AuthManager.shered.startAuthWithApple(credential: credential) { [self] (result) in
                    if result {
                        
                        FirebaseManager.shered.getProfile(userid: Auth.auth().currentUser!.uid) { profile in
                            
                            let myprofile:MyProfile = MyProfile(userid: profile.userid,
                                                      username: profile.username,
                                                      text: profile.text ?? "Learn from the mistakes of others. You can’t live long enough to make them all yourself.",
                                                      backgroundImage: imageData(imageData: Data(), name: "", url: profile.backgroundImageUrl),
                                                      profileImage: imageData(imageData: Data(), name: "", url: profile.profileImageUrl))
                            
                            DataManager.shere.setMyProfile(profile: myprofile)
                            
                            self.move()
                        }
                    }
               
            }
        }
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    func loginWithAnonymous(){
        if UserDefaults.standard.object(forKey: "userid") == nil{
            AuthManager.shered.startAuth { (result) in
                if result {
                    //遷移する
                    self.move()
                }
            }
        }
        else{
            //遷移する
            move()
        }
    }
}


    
extension LoginViewController {
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: Array<Character> =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length

            while remainingLength > 0 {
                let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

       return result
     }
}
