//
//  DataManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation

class DataManager{
    static let shere = DataManager()
    let userDefalts = UserDefaults.standard
    
    public let defaultBgImage = "https://firebasestorage.googleapis.com/v0/b/trips-14d27.appspot.com/o/background.jpg?alt=media&token=e2d91a06-160d-434a-9a60-0a30b4042f91"
    public let defaultProfileImage = "https://firebasestorage.googleapis.com/v0/b/trips-14d27.appspot.com/o/profile.png?alt=media&token=ae4e15d9-cef7-4e6a-b1bf-e9c25c4277e2"
    
    func get() -> [Diary]{
        var diary = [Diary]()
        if let data:[Diary] = userDefalts.codable(forKey: "diary")  {
            diary = data
        }
        return diary
    }
    
    func save(data:[Diary]){
        userDefalts.setCodable(data, forKey: "diary")
    }
    
    func delete(id:String){
        var data = get()
        for i in 0..<data.count{
            if id == data[i].id{
                data.remove(at: i)
                save(data: data)
                break
            }
        }
    }
    func setProfile(profile:Profile){
        userDefalts.setCodable(profile, forKey: "profile")
    }
    func getProfile() -> Profile{
      
        
        var profile = Profile(username: "NoName", text: "Profile", bgUrl: defaultBgImage, profileUrl: defaultProfileImage, isChange: true)
        
        if let data:Profile = userDefalts.codable(forKey: "profile")  {
            profile = data
        }
        return profile
    }
}




