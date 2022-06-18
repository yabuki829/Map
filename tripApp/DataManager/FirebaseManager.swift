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
    let defalultProfileImage = "gs://trips-14d27.appspot.com/profile.png"
    let defalultBackGroundImage = "gs://trips-14d27.appspot.com/background.jpg"
    
    func postDiscription(disc:Discription){
    
        database.collection("Users").document(disc.userid).collection("MyDiscription").document(disc.id).setData(
        
            ["id":disc.id,
             "userid":disc.userid,
             "title":disc.title,
             "text":disc.text,
             "latitude":disc.location?.latitude,"longitude":disc.location?.longitude,
             "created":FieldValue.serverTimestamp(),
             "imageurl":disc.image.imageUrl,
             "imagename":disc.image.name
            ]
        )
            
        let friendList = DataManager.shere.getFollow()
        for i in 0..<friendList.count{
            let frienduserid = friendList[i]
            database.collection("Users").document(frienduserid).collection("FriendDiscription").document(disc.id).setData(
                ["id":disc.id,
                    "userid":disc.userid,
                    "title":disc.title,
                    "text":disc.text,
                    "latitude":disc.location?.latitude,"longitude":disc.location?.longitude,
                    "created":FieldValue.serverTimestamp(),
                    "imageurl":disc.image.imageUrl,
                    "imagename":disc.image.name
                ]
            )
            }
        
        
    }
  
    func sendComment(text:String,messageid:String){
        let userid = Auth.auth().currentUser!.uid
        let commentid = String().generateID(5)
        database.collection("Comments").document(messageid).collection("Comment").document(commentid).setData(
            ["id":commentid,"comment":text,"userid":userid ,"created":FieldValue.serverTimestamp()]
        )
    }
    
    func getComment(messageid:String,compleation:@escaping ([Comment]) -> Void){
        
        database.collection("Comments").document(messageid).collection("Comment").order(by:"created", descending: false).addSnapshotListener{ (snapshot, error) in
            var array = [Comment]()
            print("array",array)
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
    
    
    
    //profileimageとbackgroundimage両方変更する
    func editProfileA(text:String?,username:String,bgImagedata:Data?,proImagedata:Data?,compleation:@escaping (Bool) -> Void){
        print("両方変更する")
        let userid = Auth.auth().currentUser!.uid
        StorageManager.shered.uploadPofileImage(imageData: proImagedata!) { (profileimagedata) in
            StorageManager.shered.uploadBackgroundImage(imageData: bgImagedata!) { (backgroundimagedata) in
                
                self.database.collection("Profile").document(userid).setData(
                    ["userid":userid,"username":username,
                     "text":text ?? "",
                     "backgroundImage": backgroundimagedata.imageUrl ,
                     "profileImage":profileimagedata.imageUrl
                    ]
                )
                var profile = DataManager.shere.getMyProfile()
                profile.profileImage = imageData(imageData: proImagedata!, name: profileimagedata.name, url: profileimagedata.imageUrl)
                profile.backgroundImage = imageData(imageData: bgImagedata!, name: backgroundimagedata.name, url: backgroundimagedata.imageUrl)
                DataManager.shere.setMyProfile(profile: profile)
                compleation(true)
            }
        }
    }
    
  
    func editProfileB(text:String?,username:String,bgImagedata:Data?,proImagedata:Data?,backgroundimageurl:String,profileimageurl:String,compleation:@escaping (Bool) -> Void){
        let userid = Auth.auth().currentUser!.uid
        print("片方だけ変更")
        //bgimagedataが空 profileだけを変更する
        if bgImagedata == nil {
            print("Profileの画像を変更する")
            StorageManager.shered.uploadPofileImage(imageData: proImagedata!) { (result) in
                
                self.database.collection("Profile").document(userid).setData(
                    ["userid":userid,"username":username,
                     "text":text ?? "",
                     "backgroundImage":backgroundimageurl  ,
                     "profileImage":result.imageUrl
                    ]
                )
                var profile = DataManager.shere.getMyProfile()
                profile.profileImage = imageData(imageData: proImagedata!, name: result.name, url: result.imageUrl)
                
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
                     "text":text ?? "",
                     "backgroundImage":backgroundimageurl ,
                     "profileImage":result.imageUrl 
                    ]
                )

                var profile = DataManager.shere.getMyProfile()
                profile.backgroundImage = imageData(imageData: bgImagedata!, name: result.name, url: profileimageurl)
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
             "text":text ?? "",
             "backgroundImage":backgroundImageUrl ?? "background" ,
             "profileImage":profileImageUrl ?? "person.crop.circle.fill"
            ]
        )

        data.text = text!
        data.username = username
        //userdefaltsに保存する　profileを
        DataManager.shere.setMyProfile(profile: data)
        compleation(true)
    }
    
    
    //useridをセットする
    
    func setUserID(userid:String){
        let id:String = Auth.auth().currentUser!.uid
        database.collection("userid").document(userid).setData(
            ["userid": id]
        )
       
    }
    func setUseridToRDatabase(userid:String){
        rdatabase.child("users").child(userid).setValue(["userid": userid])
    }
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
        self.database.collection("Profile").document(userid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                return
            }
            let data = snapshot!.data()
            if let userid       = data?["userid"],
               let username     = data?["username"],
               let profileimage = data?["profileImage"],
               let backgroundimage = data?["backgroundImage"],
               let text         = data?["text"]{
                
                let profile = Profile(userid: userid as! String,
                                      username: username as! String,
                                      text: text as! String,
                                      backgroundImageUrl: backgroundimage as! String,
                                      profileImageUrl: profileimage as! String)
              compleation(profile)
                
            }
            else{
                let profile = Profile(userid: "error", username: "No Name", backgroundImageUrl: "background", profileImageUrl: "person.crop.circle.fill")
                  compleation(profile)
            }
        }
    }
    
    func getMyUserid() -> String{
        return Auth.auth().currentUser!.uid
    }
    func getFriendProfile(friendList: [String],compleation:@escaping ([Profile]) -> Void){
        var profileList = [Profile]()
        print(friendList.count,"回")
        for i in 0..<friendList.count{
            print(i + 1 , "回目")
            let userid = friendList[i]
            self.database.collection("Profile").document(userid).addSnapshotListener { (snapshot, error) in
                if let error = error{
                    print(error)
                    return
                }
                let data = snapshot!.data()
                if let userid       = data!["userid"],
                   let username     = data!["username"],
                   let profileimage = data!["profileImage"],
                   let bgimage      = data!["backgroundImage"],
                   let text         = data!["text"]{
                    print("OK")
                    let profile = Profile(userid: userid as! String,
                                          username: username as! String,
                                          text: text as? String,
                                          backgroundImageUrl: bgimage as! String,
                                          profileImageUrl:profileimage as! String)
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
    func getDiscription(userid:String,compleation:@escaping ([Discription]) -> Void){
        database.collection("Users").document(userid).collection("MyDiscription").addSnapshotListener { (snapshot, error) in
            var discriptionList = [Discription]()
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let title = data["title"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"]{
                    let date = created.dateValue()
                    print("title:",title)
                    let disc = Discription(id: id as! String,
                                           userid: userid as! String,
                                           title: title as! String,
                                           text: text as! String,
                                           location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                           image: ProfileImage(imageUrl: imageurl as! String, name: imagename as! String), created: date)
                    discriptionList.append(disc)
                }
            }
            DispatchQueue.main.async {
                compleation(discriptionList)
            }
        }
    }
   
    
    
    func getFriendDiscription(compleation:@escaping ([Discription]) -> Void){
        print("友達の投稿を取得します")
        let userid = getMyUserid()
        var discriptionList = [Discription]()
        //24時間以内の投稿を取得する　todo
        let startDate = Date()
        database.collection("cities")
            .order(by: "serverDate")
            .start(at: [startDate])
            .end(at: <#T##[Any]#>)
        
        database.collection("Users").document(userid).collection("FriendDiscription").order(by:"created", descending: false).getDocuments{ (snapshot, error) in
            if let error = error {
                print("エラー",error)
                return
            }
            print("取得中")
            for document in snapshot!.documents {
                let data = document.data()
                if let id = data["id"],
                   let userid = data["userid"],
                   let title = data["title"],
                   let text = data["text"],
                   let latitude = data["latitude"],
                   let longitude = data["longitude"],
                   let created = data["created"] as? Timestamp,
                   let imageurl = data["imageurl"],
                   let imagename = data["imagename"]{
                    let date = created.dateValue()
                    print("title:",title)
                    let disc = Discription(id: id as! String,
                                           userid: userid as! String,
                                           title: title as! String,
                                           text: text as! String,
                                           location: Location(latitude: latitude as! Double, longitude: longitude as! Double),
                                           image: ProfileImage(imageUrl: imageurl as! String, name: imagename as! String), created: date)
                    discriptionList.append(disc)
                }
                
            }
            DispatchQueue.main.async {
                print("取得完了")
                compleation(discriptionList)
            }
        }
        
    }
    
    
    func follow(friendid :String){
        let userid = Auth.auth().currentUser!.uid
        self.database.collection("Users").document(userid).collection("FriendIdList").document(friendid).setData(
            ["FriendID":friendid]
        )
    }
    
    func getFriendIdList(userid:String,compleation:@escaping ([String]) -> Void){
        var friendIdList = [String]()
        database.collection("Users").document(userid).collection("FriendIdList").addSnapshotListener { (snapshot, error) in
            for document in snapshot!.documents {
                let data = document.data()
                if let friendID = data["FriendID"]{
                    friendIdList.append(friendID as! String)
                }
            }
            DispatchQueue.main.async {
                compleation(friendIdList)
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
        let friendList = DataManager.shere.getFollow()
        for i in 0..<friendList.count {
            deleteFriendDiscription(friendID: friendList[i], postID: postID)
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
        database.collection("Users").document(userID).collection("MyDiscription").getDocuments { (snapshot, error) in
            if let error = error{
                print("エラー",error)
                return
            }
            
            for document in snapshot!.documents{
                document.reference.delete()
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
    
    private func deleteFriendDiscription(friendID:String,postID:String){
        database.collection("Users").document(friendID).collection("FriendDiscription").document(postID).delete()
    }
  
    func deleteComment(postID:String,commentID:String){
        //ユーザーがコメントを削除する場合に使う
        database.collection("Comments").document(postID).collection("Comment").document(commentID).delete()
    }
}





// Firestore         大きいデータを少ないやりとり
// realtimeDatabase  小さいデータを何度もやりとりする場合にお得



// Chatでのメッセージの送受信
extension FirebaseManager {
    //新しいトークを作成する
    func createChatroom(currntUser:myProfile,otherUser:Profile,message:Message,compleation: @escaping (Bool) -> Void){
        if currntUser.userid == "error" || otherUser.userid == "errror"{
            print("userid が　エラーです")
            compleation(false)
            return
        }
         
        let userid = currntUser.userid
        let ref =  rdatabase.child("users").child("\(userid)")
        ref.observeSingleEvent(of: .value, with: { [self] snapshot in
            print(snapshot.value)
            guard var usernode = snapshot.value as? [String: Any] else {
                print("Userが登録されていません")
                compleation(false)
                return
            }
            
            print("usernode",usernode)
            var messageText = ""
            switch message.kind {
            
            case .text(let text):
                messageText = text
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let convarsationID = "convarsations_\(message.messageId)"
            let dateString = message.sentDate.toString()
            
            let newConvarsations:[String:Any] = [
                "id":convarsationID,
                "other_user_id":otherUser.userid,
                "latest_message": [
                    "date":dateString,
                    "message":messageText,
                    "is_read": false
                ]
            ]
            
            let recipientNewConvarsations:[String:Any] = [
                "id":convarsationID,
                "other_user_id":currntUser.userid,
                "latest_message": [
                    "date":dateString,
                    "message":messageText,
                    "is_read": false
                ]
            ]
            
            
            //相手のconvasationにメッセージを反映させる
            rdatabase.child("users").child("convarsations").observe(.value) { (sanpshot) in
                if var convasations = snapshot.value as? [[String:Any]]{
                    convasations.append(recipientNewConvarsations)
                    rdatabase.child("users").child(otherUser.userid).child("convarsations").setValue([convasations])
                }
                else{
                    rdatabase.child("users").child(otherUser.userid).child("convarsations").setValue([recipientNewConvarsations])
                }
            }
            
            //chatroomがあれば
            if var convarsations = usernode["convarsations"] as? [[String:Any]] {
                print("トークがありました")
                usernode["convarsations"] = convarsations
                convarsations.append(newConvarsations)
                
                ref.setValue(usernode) { [weak self](error, _) in
                    guard error == nil else{
                        compleation(false)
                        return
                    }
                    self?.finishCreateingConvarsation(convarsationID: convarsationID, firstMessage: message, compleation: compleation)
                    compleation(true)
                }
            }
            else{
               //chatroomを作成する
                print("トークがないため作成します")
                usernode["convarsations"] = [
                    newConvarsations
                ]
                ref.setValue(usernode,withCompletionBlock: {[weak self] (error, _) in
                    
                    guard error == nil else{
                        print("エラ-")
                        compleation(false)
                        return
                    }
                    self?.finishCreateingConvarsation(convarsationID: convarsationID, firstMessage: message, compleation: compleation)
                    compleation(true)
                })
                
            }

            compleation(true)
        })
    }
    
    
    private func finishCreateingConvarsation(convarsationID:String,firstMessage:Message,compleation: @escaping (Bool) -> Void){
        let dateString = firstMessage.sentDate.toString()
        var messageText = ""
        
        switch firstMessage.kind {
        
        case .text(let text):
            messageText = text
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let message = [
            "id":firstMessage.messageId,
            "type":firstMessage.kind.type,
            "content":messageText,
            "date":dateString,
            "sender_userid":Auth.auth().currentUser?.uid,
            "is_read": false
        ] as [String : Any]
        
        
        let data:[String:Any] = [
            "messages":[
                message
             ]
        ]
        rdatabase.child("convarsations").child(convarsationID).setValue(message) { (error, _) in
            guard error == nil else{
                print("エラ-")
                compleation(false)
                return
            }
            compleation(true)
        }
    }
    
    
    
    
    
    //作成済みのトークをすべて取得する
    func getAllChatList(currentUser:myProfile,compleation: @escaping (Result<[ChatList],Error>) -> Void){
        
        rdatabase.child("users").child(currentUser.userid).child("convarsations").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [[String:Any]] else{
                compleation(.failure(DatabaseError.failedtoFetchObject))
                return
            }
            
            let chatList :[ChatList] = value.compactMap { dictionary in
                if let convasationId = dictionary["id"] as? String,
                   let otherUser = dictionary["other_user_id"] as? String,
                   let latestMessage = dictionary["latest_message"] as? [String:Any],
                   let date = latestMessage["date"] as? String,
                   let message = latestMessage["message"] as? String,
                   let isRead = latestMessage["is_read"] as? Bool  {
                    let latestMessageDate = LatestMessage(date: date, message: message, isRead: isRead)
                    print("取得しました")
                    return ChatList(id: convasationId, otherUserId: otherUser, latestMessage: latestMessageDate)
                }
                else{
                    print("取得失敗")
                    return nil
                    
                }
               
               
            }
            compleation(.success(chatList))
        }
    }
    
    
    
    
    
    
    
    
    //MessageID(RoomID) から　Messageを取得する
    func getAllMessage(id:String,compleation: @escaping (Result<[Message],Error>) -> Void){
        let ref = rdatabase.child("convarsations/\(id)/messages")
        ref.observeSingleEvent(of: .value) {snapshot in
            guard let value = snapshot.value as? [[String:Any]] else{
                compleation(.failure(DatabaseError.failedtoFetchObject))
                return
            }
            
            let messageList :[Message] = value.compactMap { dictionary in
             
                if let messageId = dictionary["id"] as? String,
                   let content  = dictionary["content"] as? String,
                   let dateString     = dictionary["date"] as? String,
                   let isRead   = dictionary["is_read"] as? Bool,
                   let senderId = dictionary["sender_userid"] as? String,
                   let type     = dictionary["type"] as? String{
                
                    print("取得完了")
                    let date = dateString.toDate()
                    return Message(sender: Sender(photoUrl: "", senderId: senderId, displayName: ""),
                                   messageId: messageId,
                                   sentDate: date,
                                   kind: .text(content))
                }                else{
                    print("取得失敗")
                    return nil
                    
                }
               
               
            }
            compleation(.success(messageList))
        }
    }
    // 
    func sendMessage(convarsetionid: String, currentUser:Sender, otherUser:Sender,message:Message,compleation: @escaping (Bool) -> Void){
        //1.メッセージを追加する
        //メッセージを取得するしてメッセージを追加して保存する
        print("sendMessage ------------")
        print("メッセージを取得します!!!")
        
        let ref = rdatabase.child("convarsations/\(convarsetionid)/messages")
        
        ref.observeSingleEvent(of: .value) {  [weak self]snapshot in
            guard var currentMessages = snapshot.value as? [[String:Any]] else {
                compleation(false)
                return
            }
           print("CurrntMessage",currentMessages)
            let dicMessage = self?.convertMessageIntoDictionary(message: message)
            currentMessages.append(dicMessage!)
            
            let data:[String:Any] = [
                "messages":[
                    currentMessages
                 ]
            ]
            self?.rdatabase.child("convarsations").child(convarsetionid).child("messages").setValue(currentMessages) { [weak self] (error, _) in
                guard error == nil else{
                    print("エラ-")
                    compleation(false)
                    return
                }
                //2.自分のlatestmessageを更新する
                self?.updateLatestMessage(convasationid: convarsetionid, userid: currentUser.senderId, message:message)
                //3.相手のlatestmessageを更新する
                self?.updateLatestMessage(convasationid: convarsetionid, userid:otherUser.senderId , message: message)
                compleation(true)
            }
        }
           
        
       
      
    }
    
    private func updateLatestMessage(convasationid:String,userid:String,message:Message){
        // user-userid-convasations-convasationid
        let data = convertMessageIntoDictionary(message: message)
        print("更新します")
        rdatabase.child("users").child(userid).child("convarsations").child(convasationid).setValue(data)
        
    }
    
    private func convertMessageIntoDictionary(message:Message) -> [String:Any]{
        let dateString = message.sentDate.toString()
        var messageText = ""
        
        switch message.kind {
            case .text(let text):
                messageText = text
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
        }
        
        let message = [
            "id":message.messageId,
            "type":message.kind.type,
            "content":messageText,
            "date":dateString,
            "sender_userid":message.sender.senderId,
            "is_read": false
        ] as [String : Any]
        return message
    }
}



enum DatabaseError : Error {
    case failedtoFetchObject// 取得失敗
    case entryNotFound   // データが見つからないエラー
    case duplicatedEntry   // 重複したデータによるエラー
    case invalidEntry(reason: String)   // 不正なデータによるエラー
    case unexpectedError
}



