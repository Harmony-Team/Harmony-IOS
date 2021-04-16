//
//  GroupUsersCellViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 14.03.2021.
//

import UIKit

struct GroupUsersCellViewModel {
    
//    private var imageCache = NSCache<NSString, UIImage>()
//    private var cacheKey: String {
//        project.objectID.description
//    }
    
    var userName: String {
        groupUser.login
    }

    // Cache images
    func loadUserImage(completion: @escaping (UIImage?) -> Void) {
//        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
//            completion(cachedImage)
//        } else {
//            guard let userImage = project.icon, let image = UIImage(data: eventImage) else {
//                completion(nil)
//                return
//            }
//            imageCache.setObject(image, forKey: cacheKey as NSString)
            completion(UIImage(named: "groupImage"))
//        }
    }
    
    var groupUser: GroupUsers
    init(groupUser: GroupUsers) {
        self.groupUser = groupUser
    }
}

