//
//  NewGroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewModel {
    
    var coordinator: NewGroupCoordinator!
    var coreDataManager: CoreDataManager?
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func goToShareLink() {
        print("Creating Invite Code...");
        APIManager.shared.getGroups { groups in
            APIManager.shared.createInviteCode(groupId: groups[groups.count - 1].id, days: 1)
            print(groups[groups.count - 1].name)
        }
        
        coordinator.goToShareLink()
    }
    
    /* Create New Group */
    func createNewGroup(with name: String, description: String, image: UIImage) {
        APIManager.shared.createGroup(groupName: name, groupDescr: description)
//        coreDataManager?.saveGroup(name: name, image: image)
    }
    
    /* Go To Created Group */
    func goToGroup() {
        coordinator.goToGroup()
    }

    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
    
}
