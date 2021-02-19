//
//  LoginViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class LoginViewModel {
    
    var coordinator: LoginCoordinator!
    
    /* Login user and go to profile */
    func loginUser(user: LoginUser, completion: @escaping (Result<String?, Error>) -> Void) {
        APIManager.shared.callLoginAPI(login: user, completion: { msg in
            if msg != "" {
                completion(.success(msg))
            } else {
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")

                UserProfileCache.save(user, "user")
                completion(.success(nil))
                self.coordinator.goToProfile() /* Login user. Go to profile */
            }
        })
    }
    
    /* Go to register form */
    func goToSignIn() {
        coordinator.goToRegister()
    }
    
    /* Go to forgot password view */
    func goToForgotPassword() {
        
    }
    
}
