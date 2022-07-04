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
    
    func get() -> [Discription]{
        var diary = [Discription]()
        if let data:[Discription] = userDefalts.codable(forKey: "discription")  {
            diary = data
        }
        return diary
    }
    
    func getDiscriptionSince48Hours() -> [Discription]{
        var disc = get()
        let date = Calendar.current.date(byAdding: .hour, value: 48, to: Date())!
        var modifiedDisc = [Discription]()
        for i in 0..<disc.count{
            if date >= disc[i].created{
                modifiedDisc.append(disc[i])
            }
        }
        return modifiedDisc
    }
    func save(data:[Discription]){
        userDefalts.setCodable(data, forKey: "discription")
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
        userDefalts.setCodable(profile, forKey: "myprofile")
    }
    
    func getMyProfile() -> MyProfile {
        var profile = MyProfile(userid: FirebaseManager.shered.getMyUserid(),
                                username: "No Name",
                                text: "Learn from the mistakes of others. You can’t live long enough to make them all yourself.",
                                backgroundImage: imageData(imageData: Data(), name: "background", url: "background" ),
                                profileImage: imageData(imageData: Data(), name: "person.crop.circle.fill", url: "background"))
        
        if let data:MyProfile = userDefalts.codable(forKey: "myprofile")  {
            profile = data
        }
        return profile
    }
}
