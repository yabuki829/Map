//
//  Discription.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/06/05.
//

import Foundation

import Foundation
struct Article:Codable,Equatable {
    let id       : String
    let userid   : String
    let text     : String
    let location : Location?
    let data : ProfileImage
    let thumnail: ProfileImage?
    let created  : Date
    let type     :String
    
}


enum discriptionType:Codable,Equatable {
    case video
    case image
    case ad
    case none
}
struct Location :Codable,Equatable{
    let latitude:Double
    let longitude:Double
}
