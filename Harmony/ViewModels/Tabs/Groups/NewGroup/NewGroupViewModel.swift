//
//  NewGroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewModel {
    
    var coordinator: NewGroupCoordinator!
    var coreDataManager: GroupsCoreDataManager?
    var createdGroup: NewGroup!
    
    init(coreDataManager: GroupsCoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    // TODO: SHOW INVITE CODE
    func goToShareLink() {
        let inviteCode = createdGroup.invite_code
        coordinator.goToShareLink(inviteCode: inviteCode)
    }
    
    /* Create New Group */
    func createNewGroup(with name: String, description: String, imageUrl: String) {
        APIManager.shared.createGroup(groupName: name, groupDescr: description, avatarUrl: imageUrl) { (newGroup) in
            self.createdGroup = newGroup
            DispatchQueue.main.async {
                self.goToShareLink()
            }
        }
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
