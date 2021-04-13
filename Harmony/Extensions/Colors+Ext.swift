//
//  Colors+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

extension UIColor {
    
    static var bgColor = toRGB(red: 26, green: 34, blue: 48, alpha: 1)
    static var mainColor = toRGB(red: 255, green: 87, blue: 168, alpha: 1)
    static var darkMainColor = toRGB(red: 255, green: 87, blue: 168, alpha: 0.5)

    static var buttonColor = toRGB(red: 255, green: 38, blue: 98, alpha: 1)
    
    /* Text Colors */
    static var mainTextColor = toRGB(red: 136, green: 149, blue: 175, alpha: 1)
    static var darkMainTextColor = toRGB(red: 40, green: 48, blue: 64, alpha: 1)
    static var darkTextColor = toRGB(red: 0, green: 0, blue: 0, alpha: 0.8)
    static var lightTextColor = toRGB(red: 255, green: 255, blue: 255, alpha: 0.5)
    static var redTextColor = toRGB(red: 255, green: 38, blue: 98, alpha: 1)
    static var redTextNotSelectedColor = toRGB(red: 255, green: 38, blue: 98, alpha: 0.5)
    
    /* Gradient Colors */
    static var gradientColorTop = toRGB(red: 255, green: 38, blue: 98, alpha: 1)
    static var gradientColorBottom = toRGB(red: 61, green: 38, blue: 158, alpha: 1)
    static var loginGradientColorTop = toRGB(red: 33, green: 41, blue: 57, alpha: 1)
    static var loginGradientColorBottom = toRGB(red: 22, green: 26, blue: 36, alpha: 1)
    // Menu
    static var menuGradientColorTop = toRGB(red: 246, green: 54, blue: 105, alpha: 1)
    static var menuGradientColorBottom = toRGB(red: 70, green: 52, blue: 169, alpha: 1)
    
    static func toRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
