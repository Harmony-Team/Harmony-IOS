//
//  FriendsViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class FriendsViewModel {
    
    // Menu
    var menuShow = false
    var coordinator: FriendsCoordinator!
    
    func addNewFriend() {
        coordinator.addNewFriend()
    }
    
    /* Go To Selected Section */
    func goToSelectedSection(section: MenuSection) {
        coordinator.goToSection(section: section)
    }
    
}
