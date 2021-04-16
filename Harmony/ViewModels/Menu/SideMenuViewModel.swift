//
//  SideMenuViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 13.04.2021.
//

import UIKit

class SideMenuViewModel {
    
    // Menu
    var menuShow = false
    
    let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
    let friendCoordinator = FriendsCoordinator(navigationController: UINavigationController())
    let groupCoordinator = GroupsListCoordinator(navigationController: UINavigationController())
    var sectionNames = ["Profile", "Groups", "Chats", "Friends", "Settings"]
    
    func selectedSection(at index: Int) {
        switch index {
        case 0:
            // Profile
            profileCoordinator.start()
        case 1:
            // Groups
            groupCoordinator.start()
        case 2:
            // Chats
            friendCoordinator.start()
        case 3:
            // Friends
            friendCoordinator.start()
        case 4:
            // Settings
            friendCoordinator.start()
        default:
            break
        }
        
    }
    
}
