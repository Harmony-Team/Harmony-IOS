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
    
    func goToProfile() {
        
    }
    
    func setup() {
        
    }
    
    /* VK Auth */
    func authVK() {
        
    }
    
    /* Register user. Go to profile */
    func endRegistration() {
        coordinator.goToProfile()
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
