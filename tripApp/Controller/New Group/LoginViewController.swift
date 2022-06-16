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

class LoginViewController:UIViewController{
    var currentNonce = ""
    let iconImageView:UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "地球アイコン")
        image.contentMode = .scaleAspectFit
        return image
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
    let signinWithEmaiButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign in With Email", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    let signupWithEmailButton:UIButton = {
        let button = UIButton()
        button.setTitle("Register With Email", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .white
       
        view.addSubview(iconImageView)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: view.frame.width / 4,
                             left: view.leftAnchor,paddingLeft: view.frame.width / 2 - view.frame.width / 4,
                             width: view.frame.width / 2,
                             height: view.frame.width / 2)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: iconImageView.bottomAnchor, paddingTop: 0,
                          left: view.leftAnchor, paddingLeft: 20,
                          right: view.rightAnchor, paddingRight: 20)
        
        view.addSubview(appleLoginButton)
        appleLoginButton.addTarget(self, action: #selector(loginWithApple), for: .touchUpInside)
        
        appleLoginButton.centerX(inView:view)
        appleLoginButton.anchor(top:titleLabel.bottomAnchor,paddingTop:120,
                                width: view.frame.width - 100, height: 50)
        
        
        view.addSubview(orLabel)
        orLabel.anchor(top: appleLoginButton.bottomAnchor, paddingTop: 20,
                       left: view.leftAnchor, paddingLeft: 20,
                       right: view.rightAnchor, paddingRight: 20)
        
        view.addSubview(signinWithEmaiButton)
        view.addSubview(signupWithEmailButton)
        
        
        
        let signButtonWidth = (view.frame.width - 20  - 25 * 2) / 2
        signinWithEmaiButton.anchor(top: orLabel.bottomAnchor, paddingTop: 20,
                                    left: view.leftAnchor, paddingLeft: 25,
                                    width: signButtonWidth)
        signinWithEmaiButton.addTarget(self, action: #selector(loginWithEmail), for: .touchDown)
//        20 A 10 or 10 B 20
       
        
        signupWithEmailButton.anchor(top: orLabel.bottomAnchor, paddingTop: 20,
                                     left: signinWithEmaiButton.rightAnchor, paddingLeft: 20,
                                     right: view.rightAnchor, paddingRight: 25,
                                     width: signButtonWidth)
        signupWithEmailButton.addTarget(self, action: #selector(registerWithEmail), for: .touchDown)
    }
    

    func move(){
        let nav = MainTabBarController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
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
        
        currentNonce = randomNonceString()

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = currentNonce.sha_256()

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
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

                AuthManager.shered.startAuthWithApple(credential: credential) {  (result) in
                    if result {
                        self.move()
                    }
                print("Appleログインに失敗しました")
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
