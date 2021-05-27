//
//  EditProfileViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 10.04.2021.
//

import UIKit

struct EditProfileViewModel {
    var coordinator: EditProfileCoordinator!
    
    func viewDidDisappear() {
        coordinator.goToSettings()
    }
    
}
