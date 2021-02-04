//
//  ServicesViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import SwiftyVK

class ServicesViewModel {
    
    var coordinator: ServicesCoordinator!
    let vkDelegate = VKDelegate()
    
    func goToProfile() {
        
    }
    
    func setup() {
        
    }
    
    /* VK Auth */
    func authVK() {
        VK.sessions.default.logIn(
            onSuccess: { _ in
                print("Success")
            },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
            }
        )
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
