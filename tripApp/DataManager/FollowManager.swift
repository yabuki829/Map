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
    
    func changeReciver(friendList:[Friend],reciver:[String]) -> [Friend]{
        var list = friendList
        for i in 0..<list.count {
            var isFind = false
            for j in 0..<reciver.count {
                if list[i].userid == reciver[j]{
                    list[i].isSend =  true
                    isFind = true
                    break
                }
            }
            if !isFind {
                list[i].isSend = false
            }
           
        }
        return list
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
    
    func getBlockedUser() -> [BlockUser] {
        var blockUser = [BlockUser]()
        print("blockUser",blockUser)
        if let data:[BlockUser] = userDefaults.codable(forKey: "block"){
            blockUser = data
        }
        return blockUser
    }
    func block(userid:String){
        var blockUser = getBlockedUser()
        let user = BlockUser(userid: userid, isBlock: true)
        blockUser.append(user)
        print(user)
       saveBlockList(blockList: blockUser)
    }
    func unBlock(userid:String){
        var blockedUser = getBlockedUser()
        
        for i in 0..<blockedUser.count {
            if userid == blockedUser[i].userid{
                blockedUser[i].isBlock = !blockedUser[i].isBlock
                saveBlockList(blockList: blockedUser)
                break
            }
        }
    }
    func isBlock(userid:String) -> Bool{
        let blockUser = getBlockedUser()
        for i in 0..<blockUser.count {
            if blockUser[i].userid == userid {
                print("ブロックしています")
                return true
            }
        }
        return false
    }
    func saveBlockList(blockList:[BlockUser]){
        userDefaults.setCodable(blockList, forKey: "block")
    }
    
}

struct BlockUser: Codable,Equatable{
    let userid:String
    var isBlock:Bool
}
