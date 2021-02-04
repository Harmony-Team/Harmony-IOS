//
//  LoginViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class LoginViewModel {
    
    var coordinator: LoginCoordinator!
    
    /* Go to register form */
    func goToSignIn() {
        coordinator.goToRegister()
    }
    
    /* Go to forgot password view */
    func goToForgotPassword() {
        
    }
    
}
