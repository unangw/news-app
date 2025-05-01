//
//  UIColor+Ext.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgb & 0x0000FF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
