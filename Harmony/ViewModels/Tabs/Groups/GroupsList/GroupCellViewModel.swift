//
//  GroupCellViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 18.03.2021.
//

import UIKit
import CoreData

struct GroupCellViewModel {
    
    private var imageCache = NSCache<NSString, UIImage>()
//    var onSelect: (NSManagedObjectID) -> Void = {_ in}
    var onSelect: (Int, UserGroup) -> Void = {_,_  in}
    private var cacheKey: String {
        String(group.id)
    }
    
    var groupName: String {
        group.name
    }
    
    var groupDescr: String? {
        group.description == nil ? "256 tracks" : group.description
    }
    
    // Cache images
    func loadGroupImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
        } else {
            guard let groupImage = group.avatar_url, let image = UIImage(named: groupImage) else {
                completion(UIImage(named: "groupImage1"))
                return
            }
            imageCache.setObject(image, forKey: cacheKey as NSString)
            completion(image)
        }
    }
    
    func didSelect() {
//        onSelect(group.objectID)
        onSelect(group.id, group)
    }
    
    var group: UserGroup
    init(group: UserGroup) {
        self.group = group
    }
}
