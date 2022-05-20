//
//  DatabaseManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

class FirebaseManager{
    static let shered = FirebaseManager()
    let database = Firestore.firestore()
    func sendMessage(){}
    
    func sendComment(text:String,messageid:String){
        print(text )
        print(messageid)
        let userid = Auth.auth().currentUser?.uid
        let commentid = String().generateID(8)
        print(userid)
        print(commentid)
        database.collection("Comments").document(messageid).collection("Comment").document(commentid).setData(
            ["id":commentid,"comment":text,"userid":userid ,"created":FieldValue.serverTimestamp()]
        )
    }
    
    func getComment(messageid:String,compleation:@escaping ([Comment]) -> Void){
  
        
        database.collection("Comments").document(messageid).collection("Comment").order(by:"created", descending: false).addSnapshotListener{ (snapshot, error) in
            var array = [Comment]()
            print("array",array)
            for document in snapshot!.documents {
                let data = document.data()
                
                if let id = data["id"],
                   let comment = data["comment"],
                   let userid = data["userid"],
                   let created = data["created"] as? Timestamp {
                    let date = created.dateValue()
                    print("---------------")
                  print(date)
                  
                    let newdata = Comment(id: id as! String, comment:comment as! String, userid: userid as! String, created: date)
                    array.append(newdata)
                }
            }
            DispatchQueue.main.async {
              
                compleation(array)
            }
        }
    }
    func getMessage(){}
    func setProfile(){}
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
