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
            print("Auth",self.auth)
            guard (authResult?.user) != nil else {
                compleation(false)
                return
            }
            //useridを保存する
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
//            FirebaseManager.shered.setUseridToRDatabase(userid: Auth.auth().currentUser!.uid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
        }
    }
    func startAuthWithApple(credential:AuthCredential,compleation:@escaping (Bool) -> Void){
        auth.signIn(with: credential) { (result, error) in
            if let error = error{
                print("エラー",error)
                compleation(false)
            }
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
//            FirebaseManager.shered.setUseridToRDatabase(userid: Auth.auth().currentUser!.uid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
        }
    }
    
    func startAuthWithEmail(email:String,password:String,compleation:@escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("エラー",error)
                compleation(false)
                return
            }
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
            
        }
    }
    func signinWithEmail(email:String,password:String,compleation:@escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let error = error{
                print("エラー",error)
                compleation(false)
                return
            }
            print(authResult)
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
            
            
        }
    }
    
    func loginOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
