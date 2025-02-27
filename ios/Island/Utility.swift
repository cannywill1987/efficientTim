//
//  Utility.swift
//  Runner
//
//  Created by 林智彬 on 2022/1/29.
//

import Foundation
import UserNotifications

class Utility {
    static func getColor(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        let alpha = Double((rgbValue & 0xFF000000) >> 24) / 255.0
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
   
}
