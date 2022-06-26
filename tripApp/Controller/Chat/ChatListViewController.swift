//
//  ChatList.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/06/07.
//

import Foundation
import UIKit

/*
 自分が友達登録したUserのメッセージのみを表示する。
 自分が友達をしてないuserからのメッセージは取得しても表示しない。
 理由:友達登録した時に過去のメッセージ(友達登録する以前に送信されたメッセージ)を確認できるようにするため
 */


//Conversetion(chatList) -> NewConversetion()
//                       -> ChatViewcontroller

//"conversationID":
//"otherUserid":
//"latest_message" => [
//    "date": Date()
//    "latest_message": "message"
//    "is_read": true or false
//]
struct ChatList {
    let id:String
    let otherUserId: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let message:String
    let isRead:Bool
}
class ChatListViewController:UIViewController{
    
    let tableView = UITableView()
    let messageButton : UIButton = {
        let button = UIButton()
        button.setTitle("トークを始める", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.setTitleColor(.gray, for: .highlighted )
        button.isHidden = true
        return button
    }()
    var chatList = [ChatList]()
    var chatCell:ChatListCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                         left: view.leftAnchor, paddingLeft: 0,
                         right: view.rightAnchor, paddingRight: 0,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        view.addSubview(messageButton)
        messageButton.center(inView: view)
      
        settingTableView()
        setNav()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        getChatList()
    }
    func setNav(){
        let searchButton = UIImage(systemName: "magnifyingglass")
        let searchItem = UIBarButtonItem(image:searchButton, style: .plain, target: self, action: #selector(search(sender:)))
        searchItem.tintColor = .link
        navigationItem.rightBarButtonItem = searchItem
    }
    @objc func search(sender : UIButton){
        print("search")
        let vc = NewChatViewController()
        vc.compleation = { [weak self ]result in
            print(result.username)
            self?.createNewChatRoom(profile: result)
        }
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func getChatList(){
        print("ChatListを取得します")
        let currentUser = DataManager.shere.getMyProfile()
        FirebaseManager.shered.getAllChatList(currentUser: currentUser) { [weak self] (result) in
            switch result{
            case .success(let chatList):
                print("success")
                guard !chatList.isEmpty else {
                    print("からです。終了します")
                    //emptyなら終了する
                    return
                }
                self?.chatList = chatList
                self?.tableView.reloadData()
            case .failure(let error):
                print("エラー",error)
            }
        }
        
    }
   
    func createNewChatRoom(profile: Profile){
        let vc = ChatRoomViewController()
        vc.title = profile.username
        vc.otherProfile = profile
        vc.isNewChat = true
        let nav = UINavigationController(rootViewController:vc)
        
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    func settingTableView(){
        tableView.register(ChatListCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource  = self
    }
}

extension ChatListViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatListCell
        cell.setCell(userid:chatList[indexPath.row].otherUserId ,
                     latestMessage: chatList[indexPath.row].latestMessage)
        chatCell = cell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //chat画面に遷移する
        print("遷移します")
        let vc = ChatRoomViewController()
        if let cell = tableView.cellForRow(at: indexPath) as? ChatListCell {
            vc.otherProfile = cell.profile
        }
        vc.chatListId = chatList[indexPath.row].id
        let nav = UINavigationController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}


class ChatListCell: BaseTableViewCell {
    var profile:Profile? {
        didSet{
//            profileImageView.loadImageUsingUrlString(urlString: profile!.profileImageUrl)
            profileImageView.setImage(urlString: profile!.profileImageUrl)
            usernameLabel.text = profile!.username
            userCurrentMessageLabel.isHidden = false
        }
    }
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    let userCurrentMessageLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    let dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func setupViews() {
        contentView.addSubview(profileImageView)
      
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(userCurrentMessageLabel)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 5,
                         left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 10,
                         bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 5,
                         width: 60, height: 60)
        stackView.anchor(top:safeAreaLayoutGuide.topAnchor, paddingTop: 5,
                         left: profileImageView.rightAnchor, paddingLeft: 10,
                         right: safeAreaLayoutGuide.rightAnchor, paddingRight: 10,
                        bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
    }
    func setCell(userid:String,latestMessage:LatestMessage){
        getProfile(userid: userid)
        userCurrentMessageLabel.text = latestMessage.message
        
    }
    
    func getProfile(userid:String){
        FirebaseManager.shered.getProfile(userid: userid) { (result) in
            self.profile = result
        }
    }
  
}
