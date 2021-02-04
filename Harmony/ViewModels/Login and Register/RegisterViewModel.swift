//
//  RegisterViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class RegisterViewModel {
    
    var coordinator: RegisterCoordinator!
    
    func goToServices() {
        coordinator.goToServices()
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
