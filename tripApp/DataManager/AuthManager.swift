//
//  AuthManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
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
            
            let userid = String().generateID(20)
            FirebaseManager.shered.setUserID(userid: userid)
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
            
            
        }
    }
    
    func logout(compleation:@escaping (Bool) -> Void){
        let firebaseAuth = Auth.auth()
        do {
            print("logout")
            try firebaseAuth.signOut()
                FirebaseManager.shered.deleteUserid()
                UserDefaults.standard.removeObject(forKey: "userid")
                compleation(true)
            
        } catch let signOutError as NSError {
            print("logoutに失敗しました")
            print("Error signing out: %@", signOutError)
            compleation(false)
        }
    }
    func deleteAccount(compleation:@escaping (Bool) -> Void){
        //1.accountの削除
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
            print(error)
            print("アカウント削除に失敗しました")
            } else {
            print("アカウントを削除しました")
            }
        }
        //2.profileの削除
        Firestore.firestore().collection("Profile").document(user!.uid).delete()
        //3.friendidを取得して　useridを削除する
        FirebaseManager.shered.deleteUserid()
        //4.friend id List を削除
        FirebaseManager.shered.deleteAllFollow(userid: user!.uid)
        
        //5.discription　frienddiscription mydiscription の削除
        FirebaseManager.shered.deleteAllDiscriptions(userID: user!.uid)
        //6.userdefailtsの削除
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        compleation(true)
    }
}
