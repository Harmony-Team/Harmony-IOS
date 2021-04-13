//
//  RecentActivityCellViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 09.04.2021.
//

import UIKit

struct RecentActivityCellViewModel {
    var userName: String {
        user.login.capitalized
    }
    
    var usersFollowed: [String] {
        ["Nathan Hunt", "Carolyne Miller"]
    }
    
    var timeString: String {
        "2 hours ago"
    }

    var user: User!
    init() {
        self.user = UserProfileCache.get(key: "user")
    }
}

