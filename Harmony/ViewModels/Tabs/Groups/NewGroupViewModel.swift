//
//  NewGroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class NewGroupViewModel {
    
    var coordinator: NewGroupCoordinator!
    
    func goToShareLink() {
        coordinator.goToShareLink()
    }
    
    /* Go To Created Group */
    func goToGroup() {
        coordinator.goToGroup()
    }

    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
    
}
