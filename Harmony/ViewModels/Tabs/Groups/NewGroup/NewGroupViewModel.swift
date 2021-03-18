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
        coordinator.goToShareLink()
    }
    
    /* Create New Group */
    func createNewGroup(with name: String, image: UIImage) {
        coreDataManager?.saveGroup(name: name, image: image)
    }
    
    /* Go To Created Group */
    func goToGroup() {
        coordinator.goToGroup()
    }

    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
    
}
