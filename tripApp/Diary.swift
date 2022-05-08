//
//  Diary.swift
//  tripApp
//
//  Created by Yabuki Shodai on 2022/05/08.
//

import Foundation


struct Diary{
    let id:String
    let title:String
    let image:[String]
    let text:String?
    let date:Date
    let location:Location?
    


}

struct Location {
    let latitude:Double
    let longitude:Double
}
