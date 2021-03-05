//
//  UIDevice+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 02.03.2021.
//

import UIKit

extension UIDevice {
 
    enum DeviceType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_SE2_6_6s_7_8 = "iPhone SE 2, iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown = "iPadOrUnknown"
    }
 
    var deviceType: DeviceType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_SE2_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}


/*

 import SystemConfiguration
 import UIKit

 public extension UIDevice {
   static let modelName: String = {
     var systemInfo = utsname()
     uname(&systemInfo)
     let machineMirror = Mirror(reflecting: systemInfo.machine)
     let identifier = machineMirror.children.reduce("") { identifier, element in
       guard let value = element.value as? Int8, value != 0 else { return identifier }
       return identifier + String(UnicodeScalar(UInt8(value)))
     }
     
     func mapToDevice(identifier: String) -> String {
       #if os(iOS)
       switch identifier {
       case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
       case "iPhone4,1":                               return "iPhone 4s"
       case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
       case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
       case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
       case "iPhone7,2":                               return "iPhone 6"
       case "iPhone7,1":                               return "iPhone 6 Plus"
       case "iPhone8,1":                               return "iPhone 6s"
       case "iPhone8,2":                               return "iPhone 6s Plus"
       case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
       case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
       case "iPhone8,4":                               return "iPhone SE"
       case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
       case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
       case "iPhone10,3", "iPhone10,6":                return "iPhone X"
       case "iPhone11,2":                              return "iPhone XS"
       case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
       case "iPhone11,8":                              return "iPhone XR"
       default:                                        return identifier
       }
       #endif
     }
     
     return mapToDevice(identifier: identifier)
   }()
 }

 */
