//
//  LoginViewController.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import UIKit

class LoginViewController:UIViewController{
    override func viewDidLoad() {
        self.view.backgroundColor = .blue
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "userid")
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
    func move(){
        let nav = MainTabBarController()
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
