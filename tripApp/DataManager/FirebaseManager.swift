//
//  DatabaseManager.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

//3TiT3F3eNlfzdliGvdfB

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

class FirebaseManager{
    static let shered = FirebaseManager()
    let database = Firestore.firestore()
    let rdatabase = Database.database().reference()
    func sendMessage(){}
   
    
    
    func sendComment(text:String,messageid:String){
        let userid = Auth.auth().currentUser!.uid
        let commentid = String().generateID(6)
        database.collection("Comments").document(messageid).collection("Comment").document(commentid).setData(
            ["id":commentid,"comment":text,"userid":userid ,"created":FieldValue.serverTimestamp()]
        )
    }
    
    func getComment(messageid:String,compleation:@escaping ([Comment]) -> Void){
        
        database.collection("Comments").document(messageid).collection("Comment").order(by:"created", descending: false).addSnapshotListener{ (snapshot, error) in
            var array = [Comment]()
            for document in snapshot!.documents {
                let data = document.data()
                
                if let id = data["id"],
                   let comment = data["comment"],
                   let userid = data["userid"],
                   let created = data["created"] as? Timestamp {
                    let date = created.dateValue()
                  
                    let newdata = Comment(id: id as! String, comment:comment as! String, userid: userid as! String, created: date)
                    array.append(newdata)
                }
            }
            DispatchQueue.main.async {
                compleation(array)
            }
        }
    }
    
    func deleteComment(postID:String,commentID:String){
        database.collection("Comments").document(postID).collection("Comment").document(commentID).delete()
    }
    
    
    //profileimageとbackgroundimage両方変更する
    func editProfileA(text:String,username:String,bgImagedata:Data?,proImagedata:Data?,compleation:@escaping (Bool) -> Void){
        print("両方変更する")
        let userid = Auth.auth().currentUser!.uid
        StorageManager.shered.uploadPofileImage(imageData: proImagedata!) { (profileimagedata) in
            StorageManager.shered.uploadBackgroundImage(imageData: bgImagedata!) { (backgroundimagedata) in
                
                self.database.collection("Profile").document(userid).setData(
                    ["userid":userid,"username":username,
                     "text":text ,
                     "backgroundImage":backgroundimagedata.url  ,
                     "backgroundname": backgroundimagedata.name,
                     "profileImage":profileimagedata.url,
                     "profilename":profileimagedata.name
                    ]
                )
                var profile = DataManager.shere.getMyProfile()
                profile.username = username
                profile.text = text
                profile.profileImage = ProfileImage( url: profileimagedata.url, name: profileimagedata.name)
                profile.backgroundImage = ProfileImage(url: backgroundimagedata.url, name: backgroundimagedata.name)
                DataManager.shere.setMyProfile(profile: profile)
                compleation(true)
            }
        }
    }

    func editProfileB(text:String,username:String,bgImagedata:Data?,proImagedata:Data?,profile:Profile,compleation:@escaping (Bool) -> Void){
        let userid = Auth.auth().currentUser!.uid
        //bgimagedataが空 profileだけを変更する
        
        if bgImagedata == nil {
            print("Profileの画像を変更する")
            StorageManager.shered.uploadPofileImage(imageData: proImagedata!) { (result) in
                
                self.database.collection("Profile").document(userid).setData(
                    ["userid":userid,"username":username,
                     "text":text ,
                     "backgroundImage":profile.backgroundImage.url  ,
                     "backgroundname": profile.backgroundImage.name,
                     "profileImage":result.url,
                     "profilename":result.name
                    ]
                )
                var profile = DataManager.shere.getMyProfile()
                
                profile.profileImage = ProfileImage(url: result.url, name: result.name)
                profile.username = username
                profile.text = text
                DataManager.shere.setMyProfile(profile: profile)
                compleation(true)
            }
        }
        
        //proImagedataが空
        if proImagedata == nil {
            print("Backgroundの画像を変更する")
            StorageManager.shered.uploadBackgroundImage(imageData: bgImagedata!) { (result) in
                self.database.collection("Profile").document(userid).setData(
                    ["userid":userid,
                     "username":username,
                     "text":text ,
                     "backgroundImage":result.url,
                     "backgroundname":result.name,
                     "profileImage":profile.profileImage.url,
                     "profilename" :profile.profileImage.name
                    ]
                )

                var profile = DataManager.shere.getMyProfile()
                profile.backgroundImage = ProfileImage(url: result.url,name: result.name)
                profile.username = username
                profile.text = text 
                DataManager.shere.setMyProfile(profile: profile)
                compleation(true)
            }
        }
       
    }
    
    //画像を変更しなかった場合
    func editProfileC(text:String?,username:String,backgroundImageUrl:String?,profileImageUrl:String?,compleation:@escaping (Bool) -> Void){
        let userid = Auth.auth().currentUser!.uid
        var data = DataManager.shere.getMyProfile()
        self.database.collection("Profile").document(userid).setData(
            ["userid":userid,
             "username":username,
             "text":text ?? "profile",
             "backgroundImage":data.backgroundImage.url,
             "backgroundname":data.backgroundImage.name,
             "profileImage":data.profileImage.url,
             "profilename" :data.profileImage.name
            ]
        )

        data.text = text!
        data.username = username
        //userdefaltsに保存する　profileを
        DataManager.shere.setMyProfile(profile: data)
        compleation(true)
    }
    
    
    //useridをセットする


    func getUserID(userid:String,compleation:@escaping (String) -> Void){
        print("useridを検索中")
        database.collection("userid").document(userid).getDocument { (result, error) in
            if error != nil{
                return
            }
        
            let data = result?.data()
            if let id = data?["userid"]{
                print("見つかりました")
                compleation(id as! String)
            }
            else{
                compleation("idが正しくありません")
            }
        }
    }
    
    func getProfile(userid:String,compleation:@escaping (Profile) -> Void){
        self.database.collection("Profile").document(userid).getDocument { (snapshot, error) in
            if let error = error {
                print("エラー:",error)
                return
            }
            else{
                let data = snapshot!.data()
                if let userid       = data?["userid"],
                   let username     = data?["username"],
                   let profileimage = data?["profileImage"],
                   let profilename = data?["profilename"],
                   let backgroundimage = data?["backgroundImage"],
                   let backgroundname = data?["backgroundname"],
                   let text         = data?["text"]{
                    
                    
                    let profile = Profile(userid: userid as! String, username: username as! String, text: text as! String,
                                          backgroundImage: ProfileImage(url: backgroundimage as! String, name: backgroundname as! String),
                                          profileImage: ProfileImage(url: profileimage as! String, name: profilename as! String))
                  compleation(profile)
                    
                }
                else{
                    let profile = Profile(userid: "error", username: "No Name",
                                          text: "profile",
                                          backgroundImage: ProfileImage(url: "background", name: "background"),
                                          profileImage: ProfileImage(url: "person.crop.circle.fill", name: "person.crop.circle.fill"))
                      compleation(profile)
                }
            }

        }
    }
    
    func getMyUserid() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    func getBlockUserProfile(friendList: [BlockUser],compleation:@escaping ([Profile]) -> Void){
        var profileList = [Profile]()
        print(friendList.count,"回")
        for i in 0..<friendList.count{
            print(i + 1 , "回目")
            let userid = friendList[i].userid
            self.database.collection("Profile").document(userid).getDocument { (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }
                let data = snapshot!.data()
                if let userid       = data?["userid"],
                   let username     = data?["username"],
                   let profileimage = data?["profileImage"],
                   let profilename = data?["profilename"],
                   let backgroundimage = data?["backgroundImage"],
                   let backgroundname = data?["backgroundname"],
                   let text         = data?["text"]{
                    print("OK")
                    let profile = Profile(userid: userid as! String, username: username as! String, text: text as! String,
                                          backgroundImage: ProfileImage(url: backgroundimage as! String, name: backgroundname as! String),
                                          profileImage: ProfileImage(url: profileimage as! String, name: profilename as! String))
                    profileList.append(profile)
                }
                
                DispatchQueue.main.async {
                    if i == friendList.count - 1{
                        compleation(profileList)
                    }
                }
            }
        }
    }
    
    func getFriendProfile(friendList: [Friend],compleation:@escaping ([Profile]) -> Void){
        var profileList = [Profile]()
        print(friendList.count,"回")
        for i in 0..<friendList.count{
            print(i + 1 , "回目")
            let userid = friendList[i].userid
            self.database.collection("Profile").document(userid).getDocument { (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }
                let data = snapshot!.data()
              
                if let userid       = data?["userid"],
                   let username     = data?["username"],
                   let profileimage = data?["profileImage"],
                   let profilename = data?["profilename"],
                   let backgroundimage = data?["backgroundImage"],
                   let backgroundname = data?["backgroundname"],
                   let text         = data?["text"]{
                    
                    let profile = Profile(userid: userid as! String, username: username as! String, text: text as! String,
                                          backgroundImage: ProfileImage(url: backgroundimage as! String, name: backgroundname as! String),
                                          profileImage: ProfileImage(url: profileimage as! String, name: profilename as! String))
                    profileList.append(profile)
                }
                else{
                    print("友達がアカウントを削除しています")
                        //friendList削除する
                    FollowManager.shere.unfollow(userid: userid)
                    self.unfollow(friendid: userid)
                }
                
                DispatchQueue.main.async {
                    if i == friendList.count - 1{
                        compleation(profileList)
                    }
                }
            }
        }
    }
    
    func getReceiver(disc:Article,compleation:@escaping ([String]) -> Void ){
        database.collection("Users").document(disc.userid).collection("MyDiscription").document(disc.id).getDocument { snapshot, error in
            let data = snapshot?.data()
            print("getReceiver")
            if let receiver = data?["receiverList"] {
                print("取得")
                print(receiver)
                compleation(receiver as! [String])
            }
            else {
                print("失敗")
                compleation([String]())
            }
           
        }
    }
    func postDiscription(disc:Article,compleation:@escaping (Bool) -> Void ){
        let friendList = FollowManager.shere.getFollow()
        var receiver = [String]()
        print("投稿します")
        for i in 0..<friendList.count{
            let frienduserid = friendList[i].userid
            if friendList[i].isSend{
                receiver.append(frienduserid)
            }
            
        }
        self.database.collection("Users").document(disc.userid).collection("MyDiscription").document(disc.id).setData(
                ["id":disc.id,
                 "userid":disc.userid,
                 "text":disc.text,
                 "latitude":disc.location?.latitude as Any,"longitude":disc.location?.longitude as Any,
                 "created":FieldValue.serverTimestamp(),
                 "imageurl":disc.data.url,
                 "imagename":disc.data.name,
                 "thumnailurl":disc.thumnail?.url ?? "",
                 "thumnailname":disc.thumnail?.name ?? "",
                 "receiverList":receiver,
                 "type":disc.type
                 
                ]
            )
        print("見れる人",receiver)
        DispatchQueue.global().async {
            for i in 0..<receiver.count {
                let frienduserid = receiver[i]
                self.database.collection("Users").document(frienduserid).collection("FriendDiscription").document(disc.id).setData(
                    [   "id":disc.id,
                        "userid":disc.userid,
                        "text":disc.text,
                        "latitude":disc.location?.latitude as Any,"longitude":disc.location?.longitude as Any,
                        "created":FieldValue.serverTimestamp(),
                        "imageurl":disc.data.url,
                        "imagename":disc.data.name,
                        "thumnailurl":disc.thumnail?.url ?? "",
                        "thumnailname":disc.thumnail?.name ?? "",
                        "type":disc.type
                        
                    ]
                )
            }
            print("投稿完了")
          
        }
        compleation(true)
        
        
    }
    func editReceiver(postid:String,receiver:[String]){
        //投稿を閲覧できる人を変更する
        let userid = Auth.auth().currentUser!.uid
        database.collection("Users").document(userid).collection("MyDiscription").document(postid).updateData(
            ["receiverList":receiver]
        )
        
    }
    
    func deleteDiscription(postArray:[Article]){
        let userid = Auth.auth().currentUser?.uid
        print("古い投稿を削除しました")
        for i in 0..<postArray.count {
            database.collection("Users").document(userid!).collection("FriendDiscription").document(postArray[i].id).delete()
        }
    }
    
    func getDiscription(userid:String,compleation:@escaping ([Article]) -> Void){
        database.collection("Users").document(userid).collection("MyDiscription").getDocuments { [self] (snapshot, error) in
            var articleList = [Article]()
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"],
                   let receiverList = data["receiverList"],
                   let type = data["type"] {
                    let myUserID = getMyUserid()
                    //videoならサムネイルがあるのでサムネイルを追加で取得する
                    if type as! String == "video"{
                        let thumnailurl = data["thumnailurl"]
                        let thumnailname = data["thumnailname"]
                        
                        let thumnail = ProfileImage(url: thumnailurl as! String, name: thumnailname as! String)
                        if  myUserID == userid as! String || isReceiver(myuserid: myUserID, receiver: receiverList as! [String]){
                            let date = created.dateValue()
                            let article = Article(id: id as! String,
                                                   userid: userid as! String,
                                                   text: text as! String,
                                                   location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                                   data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: thumnail, created: date, type: type as! String)
                            articleList.append(article)
                            
                        }
                    }
                    else {
                       
                        if  myUserID == userid as! String || isReceiver(myuserid: myUserID, receiver: receiverList as! [String]){
                            let date = created.dateValue()
                            let article = Article(id: id as! String,
                                                   userid: userid as! String,
                                                   text: text as! String,
                                                   location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                                   data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: nil, created: date, type: type as! String)
                            articleList.append(article)
                            
                        }
                    }
                  
                    // 自分のユーザーid　と　投稿のユーザーidが同じかどうか --> 自分の投稿なので取得
                     
                    // 自分のユーザーid が receiverListにいるかどうか　  --> receiverListにいるので取得する
                    
                  
                   
                }
            }
            DispatchQueue.main.async {

                compleation(articleList)
            }
        }
    }
   
    //公開範囲に自分が入っているかどうか
    func isReceiver(myuserid:String,receiver:[String]) -> Bool{
        for i in 0..<receiver.count{
            if myuserid == receiver[i]{
                return true
            }
        }
        return false
    }
    
    func getAd(compleation:@escaping ([Article]) -> Void){
        var articleList = [Article]()
        database.collection("Ad").getDocuments { snapshot, error in
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"],
                   let type = data["type"]{
                    let date = created.dateValue()
                    let disc = Article(id: id as! String,
                                           userid: userid as! String,
                                           text: text as! String,
                                           location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                           data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: nil, created: date, type: type as! String)
                
                        articleList.append(disc)
                    
                   
                }
                
            }
            DispatchQueue.main.async {
                print("取得完了")
                //48
                compleation(articleList)
            }
        }
        
    }
    func getFriendDiscription(compleation:@escaping ([Article]) -> Void){
        print("友達の投稿を取得します")
        let userid = getMyUserid()
        var articleList = [Article]()
        // 一日以内の投稿を取得する
        // 一週間以内の投稿を取得する
        // 一ヶ月以内の投稿を取得する
        //一年以内の投稿を取得する
        //全てを取得する
        

        database.collection("Users").document(userid).collection("FriendDiscription").addSnapshotListener{ (snapshot, error) in
            if let error = error {
                print("エラー",error)
                return
            }
            print("取得中")
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"],
                   let type = data["type"]{
                    
                    //ビデオを取得する場合
                    if type as! String == "video"{
                        let thumnailurl = data["thumnailurl"]
                        let thumnailname = data["thumnailname"]
                        let thumnail = ProfileImage(url: thumnailurl as! String, name: thumnailname as! String)
                        let date = created.dateValue()
                        let article = Article(id: id as! String,
                                               userid: userid as! String,
                                               text: text as! String,
                                               location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                               data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: thumnail, created: date, type: type as! String)
                        if FollowManager.shere.isFollow(userid: userid as! String) && !FollowManager.shere.isBlock(userid: userid as! String){
                            articleList.append(article)
                        }
                    }
                    //ビデオ以外
                    else {
                        let date = created.dateValue()
                        let article = Article(id: id as! String,
                                               userid: userid as! String,
                                               text: text as! String,
                                               location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                               data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: nil, created: date, type: type as! String)
                        if FollowManager.shere.isFollow(userid: userid as! String){
                            
                            articleList.append(article)
                        }
                    }
                    
                   
                   
                }
                
            }
            DispatchQueue.main.async {
                print("取得完了")
                articleList = MathManager.shered.sort(disc:articleList, hour: 168)
                
                
                let myDisc = DataManager.shere.getDiscriptionSince48Hours()
                articleList.append(contentsOf: myDisc)
                
                articleList.sort(by: { a, b -> Bool in
                    print("ソート中")
                    return a.created > b.created
                })
                for i in 0..<articleList.count {
                    print("--------------------------------------------")
                    print("title",articleList[i].text)
                    print("date",articleList[i].created.covertString(),articleList[i].created.secondAgo())
                }
                print("完了")
                compleation(articleList)
            }
        }
        
    }
    
    
   
    
    func deleteAllFollow(userid:String){
        
        database.collection("Users").document(userid).collection("FriendIdList").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
            }
            
        }
    }
    func deleteUserid(){
        //friendid を　取得して削除する
        let id = UserDefaults.standard.object(forKey: "userid")
        database.collection("userid").document(id as! String).delete()
    }
    func deleteDiscription(postID:String){
        //MyDiscriptionを削除する
        
        let userid = Auth.auth().currentUser!.uid
        database.collection("Users").document(userid).collection("MyDiscription").document(postID).delete()
        //FriendDiscriptionを削除する
        let friendList = FollowManager.shere.getFollow()
        for i in 0..<friendList.count {
            deleteFriendDiscription(friendID: friendList[i].userid, postID: postID)
        }
        //commentを削除する
        deleteComment(postID: postID)
    }
    func deleteAllDiscriptions(userID:String){
        database.collection("Users").document(userID).collection("FriendDiscription").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
            }
        }
        database.collection("Users").document(userID).collection("MyDiscription").getDocuments { [self] (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                let data = document.data()
                if let postID = data["id"] {
                    deleteDiscription(postID: postID as! String)
                }
                
            }
        }
        
    }
    private func deleteComment(postID:String){
        database.collection("Comments").document(postID).collection("Comment").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
                 
            for document in snapshot!.documents{
                document.reference.delete()
            }
                    
        }
    }
    func reportComment(postID:String,commentid:String,commenter:String,text:String,type:String){
        let userid = Auth.auth().currentUser?.uid
        database.collection("Report").document("Comments").collection(commentid).document(userid!).setData(
            ["通報者":userid!,
             "通報された人": commenter,
             "commentid":commentid,
             "postid":postID,
             "text": text,
             "type":type
             
            ]
            //commentid
            //通報者
        )
    }
    
    private func deleteFriendDiscription(friendID:String,postID:String){
        database.collection("Users").document(friendID).collection("FriendDiscription").document(postID).delete()
    }
  
    func report(article:Article,userid:String,category:String){
        
        self.database.collection("Report").document("discription").collection(article.id).document(userid).setData(
            ["postid":article.id,"userid":article.userid,"reporter":userid,"type":category]
        )
    }
}







extension FirebaseManager{
    func follow(friendid :String){
        let userid = Auth.auth().currentUser!.uid
        self.database.collection("Users").document(userid).collection("FriendIdList").document(friendid).setData(
            ["FriendID":friendid,"isSend":true]
        )
    }
    
    func unfollow(friendid :String){
        let userid = Auth.auth().currentUser!.uid
        self.database.collection("Users").document(userid).collection("FriendIdList").document(friendid).delete()
    }
    func getFriendIdList(userid:String,compleation:@escaping ([Friend]) -> Void){
        
        var friendIdList = [Friend]()
        database.collection("Users").document(userid).collection("FriendIdList").getDocuments { (snapshot, error) in
            for document in snapshot!.documents {
                let data = document.data()
                if data["FriendID"] != nil{
                    let friend = Friend(userid: data["FriendID"] as! String, isSend: false)
                    friendIdList.append(friend)
                }
                
            }
            DispatchQueue.main.async {
                compleation(friendIdList)
            }
        }
    }
}




extension FirebaseManager {
    func getAdvertising(location:Location,compleation:@escaping ([Article]) -> Void){
        var adArticleList = [Article]()
        database.collection("Ad").getDocuments{ (snapshot, error) in
            /*
                 id
                 text
                 image
                 latitude
                 longitude
                 imageurl
                 imagename
                
             
             */
            if let error = error {
                print("エラー",error)
                return
            }
            print("取得中")
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"]{
                    let date = created.dateValue()
                    let disc = Article(id: id as! String,
                                           userid: userid as! String,
                                           text: text as! String,
                                           location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                           data: ProfileImage(url: imageurl as! String, name: imagename as! String), thumnail: nil, created: date, type: "image")
                    adArticleList.append(disc)
                }
                
            }
            DispatchQueue.main.async {
                compleation(adArticleList)
            }
            
        }
        
    }
}   






