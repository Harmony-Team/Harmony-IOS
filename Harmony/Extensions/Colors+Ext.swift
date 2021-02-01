//
//  Colors+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

extension UIColor {
    
    static var mainColor = toRGB(red: 255, green: 52, blue: 113, alpha: 1)
    
    static func toRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
