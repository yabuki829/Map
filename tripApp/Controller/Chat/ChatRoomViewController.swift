//
//  ChatRoom.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/06/07.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message:MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}
extension MessageKind{
    var type:String{
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributedText"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "linkPreview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender:SenderType{
    var photoUrl: String
    var senderId: String
    var displayName: String
}


struct SenderMe:SenderType{
    var photodata: Data
    var senderId: String
    var displayName: String
}
class ChatRoomViewController: MessagesViewController {
    

    var chatListId = String()
    var otherProfile:Profile? {
        didSet{
            self.title = otherProfile?.username ?? "NoName"
            otherUser = Sender(photoUrl: otherProfile?.profileImageUrl ?? "",
                               senderId: otherProfile?.userid ?? "",
                               displayName: otherProfile?.username ?? "")
        }
    }
    var currentProfile:MyProfile? {
        didSet{
            currentUser = SenderMe(photodata: currentProfile!.profileImage.imageData, senderId: currentProfile!.userid, displayName: currentProfile!.username)
        }
    }
    var isNewChat = false
    private var messageList = [Message]()
    private var currentUser:SenderMe?
    private var otherUser:Sender?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messageInputBar.delegate = self
        view.backgroundColor = .white
        currentProfile = DataManager.shere.getMyProfile()
      
        setNav()
        if !chatListId.isEmpty{
            getMessage(chatListId: chatListId)
        }
      
    }
    
 
}


extension ChatRoomViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let currentSender = currentUser ,
              let messageID = createMessageID() else{
            return
        }
        // send Message
        
        let mmessage = Message(sender: currentSender,
                               messageId: messageID,
                               sentDate: Date(),
                               kind: .text(text))
        
        if isNewChat {
            //新しくchatRoomを作成する
            
          
            let errorProfile = Profile(userid: "error", username: "error",backgroundImageUrl: "background",profileImageUrl: "person.crop.circle.fill")
            
            FirebaseManager.shered.createChatroom(currntUser:currentProfile!,
                                                  otherUser: otherProfile ?? errorProfile,
                                                  message: mmessage) { [weak self]  success in
                if success {
                    print("A:メッセージを送信しました")
                    self?.isNewChat = false
                    self?.chatListId = messageID
                    self?.getMessage(chatListId: (self?.chatListId)!)
                }
                else{
                    print("A:メッセージの送信に失敗しました")
                }
            }
        }
        else{
            //メッセージを送信する
            guard !chatListId.isEmpty else {
                return
            }
//
//            FirebaseManager.shered.sendMessage(convarsetionid: chatListId, currentUser: currentUser!, otherUser: otherUser!, message: mmessage) { (result) in
//                if result {
//                    print("B:メッセージを送信しました")
//                    self.getMessage(chatListId: self.chatListId)
//
//                }
//                else{
//                    print("B:メッセージの送信に失敗しました")
//                }
//            }
            
        }
    }
    private func createMessageID() -> String? {
        guard let myuserid = currentProfile?.userid,
              let otheruserid = otherProfile?.userid
               else {
           
            return nil
        }
        let dateString = Date().toString()
        
        let newIdentifier = "\(myuserid)_\(otheruserid)_\(dateString)"
        
        return newIdentifier
    }
    
    func getMessage(chatListId:String){
        guard !chatListId.isEmpty else {
            return
        }
        FirebaseManager.shered.getAllMessage(id: chatListId) {[weak self] (result) in
            switch result{
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                
                self?.messageList = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension ChatRoomViewController:MessagesLayoutDelegate,MessagesDisplayDelegate,MessagesDataSource {
    func currentSender() -> SenderType {
        if let sender = currentUser {
            return sender
        }
        fatalError("currentUserの取得に失敗しています")
        return Sender(photoUrl: "", senderId: "1", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    
}




extension ChatRoomViewController {
    func setNav(){
        navigationController?.navigationBar.backIndicatorImage = UIImage()
     
        let backButton = UIImage(systemName: "chevron.left")
        let backItem = UIBarButtonItem(image: backButton, style: .plain, target: self, action: #selector(back(sender:)))
    
        backItem.tintColor = .darkGray
        navigationItem.leftBarButtonItem = backItem
    }
    @objc func back(sender : UIButton){
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}


