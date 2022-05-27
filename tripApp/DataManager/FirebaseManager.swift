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
    
    func postDiscription(title:String,text:String,location:Location){
        //友達全員に送信する for i in 友達の数
        //userid title text image postid ,location
        let userid = Auth.auth().currentUser?.uid
        let id = String(7)
        database.collection("Users").document(userid!).collection("MyDiscription").document().setData(
            ["id":id,"userid":userid,"text":text,"latitude":location.latitude,"longitude":location.longitude,"created":FieldValue.serverTimestamp()]
        )
        
    }
    
    func getDiscription(){
        let userid = Auth.auth().currentUser?.uid
        database.collection("Users").document(userid!).collection("Discription").addSnapshotListener { (snapshot, error) in
            
        }
    }
   
    func sendComment(text:String,messageid:String){
        let userid = Auth.auth().currentUser!.uid
        let commentid = String().generateID(5)
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
    func getMessage(){
        
    }
    
    func editProfile(text:String?,username:String,bgImage:Data?,proImage:Data?,compleation:@escaping (Bool) -> Void){
        StorageManager.shered.uploadProfile(text: text, username: username, bgImage: bgImage, proImage: proImage) { (profile) in
            let userid = Auth.auth().currentUser!.uid
            self.database.collection("Profile").document(userid).setData(
                ["userid":userid,"username":profile.username, "text": profile.text!, "backgroundImage": profile.backgroundImage?.imageUrl ?? "","profileImage":profile.profileImage?.imageUrl ?? ""]
            )
            //userdefaltsに保存する　profileを
            DataManager.shere.setProfile(profile: profile)
            compleation(true)
        }
        
    }
    func setUserID(userid:String){
        let id:String = Auth.auth().currentUser!.uid
        database.collection("Users").document(userid).setData(
            ["userid": id]
        )
    }
    func getUserID(userid:String,compleation:@escaping (String) -> Void){
        print("useridを検索中")
        database.collection("Users").document(userid).getDocument { (result, error) in
            if error != nil{
                return
            }
            print(result?.data()?.isEmpty )
        
            let data = result?.data()
            if let id = data?["userid"]{
                print("見つかりました")
                compleation(id as! String)
            }
            else{
                compleation("idが正しくありません")
            }
        }
    }
    func getProfile(userid:String,compleation:@escaping (Profile) -> Void){
        self.database.collection("Profile").document(userid).addSnapshotListener { (snapshot, error) in
            let data = snapshot!.data()
            if let userid       = data!["userid"],
               let username     = data!["username"],
               let profileimage = data!["profileImage"],
               let bgimage      = data!["backgroundImage"],
               let text         = data!["text"]{
                
                let profile = Profile(userid: userid as! String, username: username as! String, text: text as? String, backgroundImage: ProfileImage(imageUrl: bgimage as? String, name: nil), profileImage:ProfileImage(imageUrl: profileimage as? String, name: nil), isChange: true)
                compleation(profile)
                
            }
            else{
                compleation(Profile(userid: FirebaseManager.shered.getMyUserid(), username: "プロフィールが登録されていません"))
            }
        }
    }
    func getMyUserid() -> String{
        return Auth.auth().currentUser!.uid
    }
    func getFriendProfile(friendList: [String],compleation:@escaping ([Profile]) -> Void){
        var profileList = [Profile]()
        print(friendList.count,"回")
        for i in 0..<friendList.count{
            print(i + 1 , "回目")
            let userid = friendList[i]
            self.database.collection("Profile").document(userid).addSnapshotListener { (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }
                let data = snapshot!.data()
                if let userid       = data!["userid"],
                   let username     = data!["username"],
                   let profileimage = data!["profileImage"],
                   let bgimage      = data!["backgroundImage"],
                   let text         = data!["text"]{
                    print("OK")
                    let profile = Profile(userid: userid as! String, username: username as! String, text: text as? String, backgroundImage: ProfileImage(imageUrl: bgimage as? String, name: nil), profileImage:ProfileImage(imageUrl: profileimage as? String, name: nil), isChange: true)
                    profileList.append(profile)
                    print("4")
                }
                print("3")
                DispatchQueue.main.async {
                    if i == friendList.count - 1{
                        compleation(profileList)
                    }
                }
            }
            

            print("2")
        }
        print("1")
    }
}


