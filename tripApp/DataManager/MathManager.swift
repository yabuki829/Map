//
//  MathManager.swift
//  tripApp
//
//  Created by yabuki shodai on 2022/06/12.
//

import Foundation

class MathManager{
    static let shered = MathManager()
    //最大公約数の取得
    func getGreatestCommonDivisor(_ width:Int,_ height: Int) -> Int{
        guard width != 0 || height != 0 else {
            return 0
        }
        var a = Int()
        var b = Int()
        
        if width > height{
           a = width
           b = height
        }
        else {
            a = height
            b = width
        }
        
        let r =  a % b
        if r != 0 {
            return getGreatestCommonDivisor(b, r)
        } else {
            return b
        }
    }
    func calcAspectRation(_ width: Double,_ height: Double, gcd:Int) -> ascpectRation {
        let a = Int(width) / gcd
        let b = Int(height) / gcd
        print(a,b)
        return ascpectRation(x: a, y: b)
    }
    //widthの何倍なのか
    func howmanyTimes(aspectRation:ascpectRation ) -> Double{
        guard aspectRation.x != 0 || aspectRation.y != 0 else {
            return 0.0
        }
        var a = Double()
        var b = Double()
        a = Double(aspectRation.x)
        b = Double(aspectRation.y)
      
        let times = floor(b / a * 100)  / 100
        print("times",times)
        return times
    }
    
}

struct ascpectRation {
    let x: Int
    let y: Int
}



/*
 
 width = 10
 height = 3
 
 height からみると　3.33
 width  からみると　0.33
 
 height
    ↑
        → width
 */
