//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class GroupsListViewModel {
    
    var coordinator: GroupsListCoordinator!
    
    /* Create new group */
    func addNewGroupChat() {
        coordinator.addNewGroup()
    }
    
    func goToCurrentGroup() {
        coordinator.goToCreatedGroup()
    }
    
    /* Select chat group */
    func goToCurrentChat() {
        coordinator.goToGroupChat()
    }
    
}
