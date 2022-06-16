//
//  Discription.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/06/05.
//

import Foundation

import Foundation
struct Discription:Codable,Equatable {
    let id       : String
    let userid   : String
    let title    : String
    let text     : String
    let location : Location?
    let image : ProfileImage
    let created  : Date
}


struct Location :Codable,Equatable{
    let latitude:Double
    let longitude:Double
}
