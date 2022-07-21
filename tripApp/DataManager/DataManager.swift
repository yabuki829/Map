//
//  DataManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/10.
//

import Foundation

class DataManager{
    static let shere = DataManager()
    let userDefaults = UserDefaults.standard
    func allDelete(){
        userDefaults.removeObject(forKey: "discription")
        userDefaults.removeObject(forKey: "myprofile")
        userDefaults.removeObject(forKey: "userid")
    }
    
    func get() -> [Discription]{
        var diary = [Discription]()
        if let data:[Discription] = userDefaults.codable(forKey: "discription")  {
            diary = data
        }
        return diary
    }
    
    func getDiscriptionSince48Hours() -> [Discription]{
        let disc = get()
        let date = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
        var modifiedDisc = [Discription]()
        for i in 0..<disc.count{
            if date >= disc[i].created{
                modifiedDisc.append(disc[i])
            }
        }
        return modifiedDisc
    }
    func save(data:[Discription]){
        userDefaults.setCodable(data, forKey: "discription")
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
    func setMyProfile(profile:MyProfile){
        userDefaults.setCodable(profile, forKey: "myprofile")
    }
    
    func getMyProfile() -> MyProfile {
        var profile = MyProfile(userid: FirebaseManager.shered.getMyUserid(),
                                username: "No Name",
                                text: "Learn from the mistakes of others. You can’t live long enough to make them all yourself.",
                                backgroundImage: imageData(imageData: Data(), name: "background", url: "background" ),
                                profileImage: imageData(imageData: Data(), name: "person.crop.circle.fill", url: "background"))
        
        if let data:MyProfile = userDefaults.codable(forKey: "myprofile")  {
            profile = data
        }
        return profile
    }
    
    //サブスクの状態を返す
    func getSubScriptionState()-> Bool{
        let isResult = false
        if let isSubscrive = userDefaults.bool(forKey: "isSubscribe") as? Bool{
            return isSubscrive
        }
        return isResult
    }
    func saveSubScriptionState(isSubscribe:Bool){
        userDefaults.set(isSubscribe, forKey: "isSubscribe")
    }
}
