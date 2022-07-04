//
//  Profile.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation


struct Profile :Codable,Equatable{
    var userid: String
    var username:String
    var text:String?
    var backgroundImageUrl:String
    var profileImageUrl   :String
}





struct ProfileImage :Codable,Equatable{
    var url:  String
    var name    : String
    
}




struct MyProfile:Codable,Equatable{
    var userid: String
    var username:String
    var text:String
    var backgroundImage:imageData
    var profileImage   :imageData
}

struct imageData:Codable,Equatable{
    var imageData:  Data
    var name    : String
    var url     : String
}
