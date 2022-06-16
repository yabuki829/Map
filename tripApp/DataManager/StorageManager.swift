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

   
    func delete(_ name: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()

        //Removes image from storage
        let desertRef = storageRef.child("desert.jpg")

        // Delete the file
        desertRef.delete { error in
          if let error = error {
            // Uh-oh, an error occurred!
              print("エラー",error)
          } 
        }
            
    }
    
    
    func uploadPofileImage(imageData:Data,compleation:@escaping (ProfileImage) -> Void){
        print("uploadprofile")
        let userid = FirebaseManager.shered.getMyUserid()
        let filename = String().generateID(10)
        
        let imageRef = Storage.storage().reference().child("/users/\(userid)/profileimage/\(filename).jpg")
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
    
   func uploadBackgroundImage(imageData:Data,compleation:@escaping (ProfileImage) -> Void){
       print("upload background")
        let filename = String().generateID(10)
        let userid = FirebaseManager.shered.getMyUserid()
        let imageRef = Storage.storage().reference().child("/users/\(userid)/backgroundimage/\(filename).jpg")
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
    
    //投稿の画像
    func uploadImage(imageData:Data,compleation:@escaping (ProfileImage) -> Void){
        let filename = String().generateID(7)
        let userid = FirebaseManager.shered.getMyUserid()
        let imageRef = Storage.storage().reference().child("/users/\(userid)/\(filename).jpg")
        
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
    
    func deleteDiscriptionImage(image:ProfileImage){
        let userid = FirebaseManager.shered.getMyUserid()
        let filename = image.name
        let imageRef = Storage.storage().reference().child("/users/\(userid)/\(filename).jpg")
        print("画像を削除します")
        imageRef.delete { (error) in
            if let error = error {
                print("エラー",error)
                return
            }
            print("画像削除完了")
        }
    }
    func deleteProfileImage(name:String){
        let filename = name
        let userid = FirebaseManager.shered.getMyUserid()
        let imageRef = Storage.storage().reference().child("/users/\(userid)/profileimage/\(filename).jpg")
        //デフォルトの画像なら削除しない
        if name != "person.crop.circle.fill"{
            imageRef.delete { (error) in
                if let error = error {
                    print("プロフィール画像の削除に失敗しました",error)
                    
                    return
                }
                print("プロフィール画像の削除完了")
            }
        }
       
    }
    
    func deletebackgroundImage(name:String){
        let filename = name
        let userid = FirebaseManager.shered.getMyUserid()
        let imageRef = Storage.storage().reference().child("/users/\(userid)/backgroundimage/\(filename).jpg")
        //デフォルトの画像なら削除しない
        if filename != "background" {
            imageRef.delete { (error) in
                if let error = error {
                    print("プロフィール画像の削除に失敗しました",error)
                    return
                }
                print("プロフィール画像の削除完了")
            }
        }
    }

}


