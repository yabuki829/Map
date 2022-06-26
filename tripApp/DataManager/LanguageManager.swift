//
//  LanguageManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/19.
//

import Foundation

class LanguageManager {
    func getlocation() -> String{
           let locale = Locale.current
           let localeId = locale.identifier
           let locationString = localeId.components(separatedBy: "_")
           return locationString[0]
    }
}
