//
//  LanguageManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/19.
//

import Foundation

class LanguageManager {
    static let shered = LanguageManager()
    func getlocation() -> String{
        let language = NSLocale.preferredLanguages.first?.components(separatedBy: "-").first
        return language ?? "en"
    }
    
}
