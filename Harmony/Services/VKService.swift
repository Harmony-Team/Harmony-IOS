//
//  VKService.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
//import SwiftyVK
//
//class VKService: SwiftyVKDelegate {
//    let vk_app_id = "7750806"
//    let scopes: Scopes = [.offline, .audio, .email]
//    
//    init() {
//        VK.setUp(appId: vk_app_id, delegate: self)
//    }
//    
//    func vkNeedsScopes(for sessionId: String) -> Scopes {
//        return scopes
//    }
//
//    func vkNeedToPresent(viewController: VKViewController) {
//        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
//            rootController.present(viewController, animated: true)
//        }
//    }
//    
//    func vkTokenCreated(for sessionId: String, info: [String : String]) {
//        print("token created in session \(sessionId) with info \(info)")
//    }
//    
//    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
//        print("token updated in session \(sessionId) with info \(info)")
//    }
//    
//    func vkTokenRemoved(for sessionId: String) {
//        print("token removed in session \(sessionId)")
//    }
//}
