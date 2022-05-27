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
    var backgroundImage:ProfileImage?
    var profileImage   :ProfileImage?
    var isChange = true
}

struct ProfileImage :Codable,Equatable{
    var imageUrl:  String?
    var name    : String?
}


