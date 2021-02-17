//
//  ServicesViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import VK_ios_sdk

class ServicesViewModel {
    
    var coordinator: ServicesCoordinator!
    var user: User!
    
    /* VK Auth */
    func authVK() {
        
    }
    
    /* Register user. Go to profile */
    func endRegistration() {
//        APIManager.shared.callRegisterAPI(register: user)
        coordinator.goToProfile()
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
