//
//  Profile.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/18.
//

import Foundation


struct Profile :Codable,Equatable{
    var username:String
    var text:String?
    var bgUrl:String?
    var profileUrl:String?
    var isChange = true
}


