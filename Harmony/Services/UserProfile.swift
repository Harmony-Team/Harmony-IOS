//
//  UserProfile.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

struct UserProfileCache<T: Codable> {

    static func save(_ value: T, _ key: String) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get(key: String) -> T {
        var userData: T!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode(T.self, from: data)
            return userData!
        } else {
            return userData
        }
    }
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
