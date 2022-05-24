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
import FirebaseStorage

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
    
    func editProfile(text:String?,username:String,bgImage:Data?,proImage:Data?,compleation:@escaping (Bool) -> Void){
        StorageManager.shered.uploadProfile(text: text, username: username, bgImage: bgImage, proImage: proImage) { (profile) in
            let userid = Auth.auth().currentUser?.uid
            self.database.collection("Profile").document(userid!).setData(
                ["username":profile.username, "text": profile.text!, "backgroundImage": profile.backgroundImage ?? "","profileImage":profile.profileImage ?? ""]
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


class StorageManager{
    static let shered = StorageManager()

    func uploadProfile(text:String?,username:String,bgImage:Data?,proImage:Data?,compleation:@escaping (Profile) -> Void){
        //1. 画像のみ更新する場合
        //2. バックグラウンド画像を更新する場合
        //3. プロフィール画像を更新する場合
        //4. 両方の画像を更新する
        
        if bgImage?.isEmpty == true  && proImage?.isEmpty == true{
            print("A")
            let profile = Profile(username: username, text: text, backgroundImage: nil, profileImage: nil, isChange: true)
            compleation(profile)
        }
        
        if bgImage?.isEmpty == false && proImage?.isEmpty == true {
            print("B")
            uploadBackgroundImage(imageData: bgImage!) { (data) in
                let profile = Profile(username: username, text: text, backgroundImage: ProfileImage(imageUrl: data.imageUrl, name: data.name), profileImage: nil, isChange: true)
                compleation(profile)
            }
        }
        if proImage?.isEmpty == false && bgImage?.isEmpty == true{
            print("C")
            uploadPofileImage(imageData: proImage!) { (data) in
                
                let profile = Profile(username: username, text: text, backgroundImage: nil, profileImage: ProfileImage(imageUrl: data.imageUrl, name: data.name), isChange: true)
                compleation(profile)
            }
        }
        
        if proImage?.isEmpty == false && bgImage?.isEmpty == false{
            print("D")
            StorageManager.shered.uploadBackgroundImage(imageData: bgImage!) { [self] (backgroundimage) in
                uploadPofileImage(imageData: proImage!) { (profileimage) in
                    let profile = Profile(username: username, text: text, backgroundImage: ProfileImage(imageUrl: backgroundimage.imageUrl, name: backgroundimage.name), profileImage: ProfileImage(imageUrl: profileimage.imageUrl, name: profileimage.name), isChange: true)
                    compleation(profile)
                        
                }
                
            }
        }
    }
    func delete(_ name: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()

        //Removes image from storage
        let desertRef = storageRef.child("desert.jpg")

        // Delete the file
        desertRef.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // File deleted successfully
          }
        }
            
    }
    
    private func uploadPofileImage(imageData:Data,compleation:@escaping (ProfileImage) -> Void){
        
        let filename = String().generateID(10)
        let imageRef = Storage.storage().reference().child("/profileimage/\(filename).jpg")
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print(error)
            return
           }

        imageRef.downloadURL { (url, error) in
            if let error = error {
                print(error)
            return
            }
            guard let url = url else { return }
            let urlString = url.absoluteString
            let data = ProfileImage(imageUrl: urlString, name: filename)
            compleation(data)
            }
        }
        
    }
    private func uploadBackgroundImage(imageData:Data,compleation:@escaping (ProfileImage) -> Void){
        let filename = String().generateID(10)
        let imageRef = Storage.storage().reference().child("/backgroundimage/\(filename).jpg")
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                print(error)
            return
           }

        imageRef.downloadURL { (url, error) in
            if let error = error {
                print(error)
            return
            }
            guard let url = url else { return }
            
            let urlString = url.absoluteString
            let data = ProfileImage(imageUrl: urlString, name: filename)
            compleation(data)
            }
        }
    }
}
