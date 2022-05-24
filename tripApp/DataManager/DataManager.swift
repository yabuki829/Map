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
      
        
        var profile = Profile(username: "No Name", text: "", backgroundImage: ProfileImage(imageUrl: "defaultsBG", name: "background"), profileImage: ProfileImage(imageUrl: "defaultsPRO", name: "profile"), isChange: false)
        
        if let data:Profile = userDefalts.codable(forKey: "profile")  {
            profile = data
        }
        return profile
    }
}




