//
//  StorageManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/27.
//

import Foundation
import Firebase
import FirebaseStorage

class StorageManager{
    static let shered = StorageManager()

    func uploadProfile(text:String?,username:String,bgImage:Data?,proImage:Data?,compleation:@escaping (Profile) -> Void){
        //1. 画像のみ更新する場
        //2. バックグラウンド画像を更新する場合
        //3. プロフィール画像を更新する場合
        //4. 両方の画像を更新する
        
        if bgImage?.isEmpty == true  && proImage?.isEmpty == true{
            print("A")
            let profile = Profile(userid: FirebaseManager.shered.getMyUserid(), username: username, text: text, backgroundImage: nil, profileImage: nil, isChange: true)
            compleation(profile)
        }
        
        if bgImage?.isEmpty == false && proImage?.isEmpty == true {
            print("B")
            uploadBackgroundImage(imageData: bgImage!) { (data) in
                let profile = Profile(userid: FirebaseManager.shered.getMyUserid(), username: username, text: text, backgroundImage: ProfileImage(imageUrl: data.imageUrl, name: data.name), profileImage: nil, isChange: true)
                compleation(profile)
            }
        }
        if proImage?.isEmpty == false && bgImage?.isEmpty == true{
            print("C")
            uploadPofileImage(imageData: proImage!) { (data) in
                
                let profile = Profile(userid: FirebaseManager.shered.getMyUserid(), username: username, text: text, backgroundImage: nil, profileImage: ProfileImage(imageUrl: data.imageUrl, name: data.name), isChange: true)
                compleation(profile)
            }
        }
        
        if proImage?.isEmpty == false && bgImage?.isEmpty == false{
            print("D")
            StorageManager.shered.uploadBackgroundImage(imageData: bgImage!) { [self] (backgroundimage) in
                uploadPofileImage(imageData: proImage!) { (profileimage) in
                    let profile = Profile(userid: FirebaseManager.shered.getMyUserid(), username: username, text: text, backgroundImage: ProfileImage(imageUrl: backgroundimage.imageUrl, name: backgroundimage.name), profileImage: ProfileImage(imageUrl: profileimage.imageUrl, name: profileimage.name), isChange: true)
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
