//
//  SideMenuViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 13.04.2021.
//

import UIKit

enum MenuSection {
    case Profile
    case Groups
    case Friends
    case Settings
}

class SideMenuViewModel {
    
    // Menu
    var menuShow = false
    
    let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
    let friendCoordinator = FriendsCoordinator(navigationController: UINavigationController())
    let groupCoordinator = GroupsListCoordinator(navigationController: UINavigationController())
    var sectionNames = ["Profile", "Groups", "Friends", "Settings"]
    
    func selectedSection(at index: Int) -> MenuSection {
        switch index {
        case 0:
            // Profile
            return .Profile
        case 1:
            // Groups
            return .Groups
        case 2:
            // Friends
            return .Friends
        case 3:
            // Settings
            return .Settings
        default:
            break
        }
        return .Profile
    }
    
}
