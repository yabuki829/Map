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
        print("スタート")
        auth.signInAnonymously() { authResult, error in
            guard (authResult?.user) != nil else {
                compleation(false)
                return
            }
            let userid = self.auth.currentUser?.uid
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
            let userid = self.auth.currentUser?.uid
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
            let userid = self.auth.currentUser?.uid
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
            
        }
    }
    func signinWithEmail(email:String,password:String,compleation:@escaping (Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error{
                print("エラー",error)
                compleation(false)
                return
            }
            
            let userid = self?.auth.currentUser?.uid
            UserDefaults.standard.setValue(userid, forKey: "userid")
            compleation(true)
            
            
        }
    }
    
    func logout(compleation:@escaping (Bool) -> Void){
        let firebaseAuth = Auth.auth()
        do {
            print("logout")
            try firebaseAuth.signOut()
             
                UserDefaults.standard.removeObject(forKey: "userid")
                compleation(true)
            
        } catch let signOutError as NSError {
            print("logoutに失敗しました")
            print("Error signing out: %@", signOutError)
            compleation(false)
        }
    }
    func deleteAccount(compleation:@escaping (Bool) -> Void){
       
        let user = Auth.auth().currentUser
        //2.profileの削除
        print("profileの削除")
        Firestore.firestore().collection("Profile").document(user!.uid).delete()
        //4.friend id List を削除
        print("friend id List を削除")
        FirebaseManager.shered.deleteAllFollow(userid: user!.uid)
        
        //5.discription　frienddiscription mydiscription の削除
        print("discription　frienddiscription mydiscription の削除")
        FirebaseManager.shered.deleteAllDiscriptions(userID: user!.uid)
        
        //6.userdefailtsの削除
        print("userdefailtsの削除")
        DataManager.shere.allDelete()
        
        //7.今まで投稿していた画像を全て削除する
        print("今まで投稿していた画像を全て削除する")
        StorageManager.shered.deleteAll(userid: (user?.uid)!) { result in
            if result{
                user?.delete { error in
                    if let error = error {
                    print(error)
                    print("アカウント削除に失敗しました")
                    } else {
                    print("アカウントを削除しました")
                        compleation(true)
                    }
                }
            }
            else {
                print("エラー")
            }
        }
        
       
    }
}
