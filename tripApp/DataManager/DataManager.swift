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
      
    
        var profile = Profile(userid: FirebaseManager.shered.getMyUserid(), username: "No Name", text: "Learn from the mistakes of others. You can’t live long enough to make them all yourself.", backgroundImage: ProfileImage(imageUrl: "defaultsBG", name: "background"), profileImage: ProfileImage(imageUrl: "defaultsPRO", name: "profile"), isChange: false)
        
        if let data:Profile = userDefalts.codable(forKey: "profile")  {
            profile = data
        }
        return profile
    }
    func follow(userid:String){
        var follower = getFollow()
        follower.append(userid)
        saveFollow(follower: follower)
    }
    
    func unfollow(userid:String){
        var follower = getFollow()
        for i in 0..<follower.count{
            if follower[i] == userid{
                follower.remove(at: i)
                break
            }
        }
        saveFollow(follower: follower)
        
    }
    func saveFollow(follower:[String]){
        userDefalts.setValue(follower, forKey: "follow")
    }
    func getFollow() ->[String]{
        var follower = [String]()
        if let data = userDefalts.object(forKey: "follow"){
            follower = data as! [String]
        }
        return follower
    }
}




class FollowManager {
    static let shere = FollowManager()
    let userDefaults = UserDefaults.standard
    
    func follow(userid:String){
        var follower = getFollow()
        follower.append(userid)
        saveFollow(follower: follower)
    }
    
    func unfollow(userid:String){
        var follower = getFollow()
        for i in 0..<follower.count{
            if follower[i] == userid{
                follower.remove(at: i)
                break
            }
        }
        saveFollow(follower: follower)
        
    }
    func saveFollow(follower:[String]){
        userDefaults.setValue(follower, forKey: "follow")
    }
    func getFollow() ->[String]{
        var follower = [String]()
        if let data = userDefaults.object(forKey: "follow"){
            follower = data as! [String]
        }
        return follower
    }
    func isFollow(userid:String) -> Bool{
        let follower = getFollow()
        for i in 0..<follower.count{
            if follower[i] == userid{
                return false
            }
        }
        return true
    }
    func isME(userid:String) -> Bool{
        let myuserid = FirebaseManager.shered.getMyUserid()
        if userid == myuserid {
            return true
        }
        else{
            return false
        }
    }
}

