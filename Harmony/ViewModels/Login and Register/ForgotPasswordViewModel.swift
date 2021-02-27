//
//  ForgotPasswordViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 22.02.2021.
//

import UIKit

class ForgotPasswordViewModel {
    
    var coordinator: ForgotPasswordCoordinator!
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
