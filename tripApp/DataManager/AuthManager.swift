//
//  AuthManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import FirebaseAuth

class AuthManager{
    static let shered = AuthManager()
    private let auth = Auth.auth()
    func startAuth(compleation:@escaping (Bool) -> Void){
        auth.signInAnonymously() { authResult, error in
            guard (authResult?.user) != nil else {
                compleation(false)
                return
            }
            //useridを保存する
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
        }
    }
}
