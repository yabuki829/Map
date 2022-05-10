//
//  Diary.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/08.
//

import Foundation


struct Diary:Codable,Equatable{
    let id:String
    let image:Data
    let text:String?
    let date:Date
    let location:Location?
    


}

struct Location :Codable,Equatable{
    let latitude:Double
    let longitude:Double
}
