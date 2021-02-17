//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class GroupViewModel {
    
    var coordinator: GroupCoordinator!
    
    /* Create new group */
    func addNewGroupChat() {
        print("SS")
    }
    
    /* Select chat group */
    func goToCurrentChat() {
        coordinator.goToGroupChat()
    }
    
}
