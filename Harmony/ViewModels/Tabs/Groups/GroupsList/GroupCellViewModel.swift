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
    var onSelect: (NSManagedObjectID) -> Void = {_ in}
    private var cacheKey: String {
        group.objectID.description
    }
    
    var groupName: String? {
        group.name
    }
    
    // Cache images
    func loadGroupImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
        } else {
            guard let groupImage = group.image, let image = UIImage(data: groupImage) else {
                completion(nil)
                return
            }
            imageCache.setObject(image, forKey: cacheKey as NSString)
            completion(image)
        }
    }
    
    func didSelect() {
        onSelect(group.objectID)
    }
    
    var group: Group
    init(group: Group) {
        self.group = group
    }
}
