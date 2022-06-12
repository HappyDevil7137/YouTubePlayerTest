//
//  UIColor+Extension.swift
//  TestYouTubePlayer
//
//  Created by Golos on 18.05.2022.
//

import UIKit


extension UIColor {
    
    convenience init(hexValue: String, alpha: CGFloat = 1.0) {
        let r, g, b: CGFloat
        
        let start = hexValue.index(hexValue.startIndex, offsetBy: 1)
        let hexColor = String(hexValue[start...])
        
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        scanner.scanHexInt64(&hexNumber)
        r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
        b = CGFloat((hexNumber & 0x0000FF) >> 0) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
