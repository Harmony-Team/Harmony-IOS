//
//  UIFont+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 02.03.2021.
//

import UIKit

enum FontSize {
    case Small
    case Medium
    case Big
}

extension UIFont {
    
    static func setFont(size: FontSize) -> UIFont {
        let deviceType = UIDevice.current.deviceType
         
        switch deviceType {
         
        case .iPhone4_4S:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 6)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 8)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 12)!) }
        case .iPhones_5_5s_5c_SE:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 9)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 11)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 15)!) }
        case .iPhones_SE2_6_6s_7_8:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 10)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 12)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 16)!) }
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 12)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 14)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 18)!) }
        case .iPhoneX:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 12)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 14)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 18)!) }
        default:
            if size == .Small { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 12)!) }
            if size == .Medium { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 14)!) }
            if size == .Big { return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 18)!) }
        }
        return UIFontMetrics.default.scaledFont(for: UIFont(name: "Lato-Regular", size: 18)!)
    }
    
}
