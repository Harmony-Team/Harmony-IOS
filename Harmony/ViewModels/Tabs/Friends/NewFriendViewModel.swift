//
//  NewFriendViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

class NewFriendViewModel {
    
    var coordinator: NewFriendCoordinator!
    
    func closeWindow() {
        coordinator.closeWithoutSaving()
    }
    
}
