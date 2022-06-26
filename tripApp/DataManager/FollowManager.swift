//
//  FollowManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/21.
//

import Foundation

class FollowManager {
    
    static let shere = FollowManager()
    let userDefaults = UserDefaults.standard
    
    func follow(userid:String){
        var follower = getFollow()
        let friend = Friend(userid: userid, isSend: true)
        follower.append(friend)
        saveFollow(follower: follower)
    }
    
    func unfollow(userid:String){
        var follower = getFollow()
        for i in 0..<follower.count{
            if follower[i].userid == userid{
                follower.remove(at: i)
                break
            }
        }
        saveFollow(follower: follower)
        
    }
    func saveFollow(follower:[Friend]){
        userDefaults.setCodable(follower, forKey: "follow")
    }
    
    func getFollow() ->[Friend]{
        var follower = [Friend]()
        if let data:[Friend] = userDefaults.codable(forKey: "follow"){
            follower = data
        }
        return follower
    }
    func isFollow(userid:String) -> Bool{
        let follower = getFollow()
        for i in 0..<follower.count{
            if follower[i].userid == userid{
                return true
            }
        }
        return false
    }
    
    func changeisSend(friend:Friend){
        var friendList = getFollow()
        
        for i in 0..<friendList.count{
            if friendList[i].userid == friend.userid{
                friendList[i].isSend = friend.isSend
                saveFollow(follower: friendList)
                print(friend.isSend,"に変更しました")
                break
            }
        }
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
