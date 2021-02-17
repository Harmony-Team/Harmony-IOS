//
//  Colors+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

extension UIColor {
    
    static var mainColor = toRGB(red: 255, green: 87, blue: 168, alpha: 1)
    static var darkMainColor = toRGB(red: 255, green: 87, blue: 168, alpha: 0.5)
    static var darkTextColor = toRGB(red: 0, green: 0, blue: 0, alpha: 0.8)
    
    static func toRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
