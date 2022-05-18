//
//  DatabaseManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class FirebaseManager{
    static let shered = FirebaseManager()
    let database = Firestore.firestore()
    func sendMessage(){}
    func sendComment(){}
    func setProfile(){}
    func getMessage(){}
    func setUserID(userid:String){
        let id:String = Auth.auth().currentUser!.uid
        database.collection("Users").document(userid).setData(
            ["userid": id]
        )
    }
    func getUserID(userid:String,compleation:@escaping (String) -> Void){
        database.collection("Users").document(userid).getDocument { (result, error) in
            if result != nil{
                return
            }
            let data = result!.data()
            if let id = data!["userid"]{
                compleation(id as! String)
            }
        }
    }
}
