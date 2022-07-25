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
            diary.sort(by: { a, b -> Bool in
                return a.created > b.created
            })
            for i in 0..<diary.count {
                print(diary[i].created.covertString() ,diary[i].created.secondAgo())
            }
        }
        return diary
    }
    
    
    
    func getDiscriptionSince48Hours() -> [Discription]{
        let disc = get()
        let date = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        print("日より後を取得します",date.toString()) // 2022年07月22日Fri　21時48分45秒
        var modifiedDisc = [Discription]()
        
        for i in 0..<disc.count{
            if date <= disc[i].created{
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
    func setMyProfile(profile:Profile){
        userDefaults.setCodable(profile, forKey: "profile")
    }
    
    func getMyProfile() -> Profile {
        var profile = Profile(userid: FirebaseManager.shered.getMyUserid(),
                                username: "No Name",
                                text: "profile",
                                backgroundImage: ProfileImage(url: "background", name: "background" ),
                                profileImage: ProfileImage(url: "background", name: "person.crop.circle.fill"))
        
        if let data:Profile = userDefaults.codable(forKey: "profile")  {
            profile = data
        }
        return profile
    }
    
    //サブスクの状態を返す

}
