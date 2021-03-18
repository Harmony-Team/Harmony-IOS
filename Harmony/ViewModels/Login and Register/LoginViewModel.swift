//
//  LoginViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class LoginViewModel {
    
    var coordinator: LoginCoordinator!
    
    /* Login user and go to token validation */
    func loginUser(user: LoginUser, completion: @escaping (Result<String?, Error>) -> Void) {
        APIManager.shared.callLoginAPI(login: user, completion: { (msg, token) in
            if msg != "" {
                completion(.success(msg))
            } else {
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")

                UserProfileCache.save(user, "user")
                completion(.success(nil))
                self.validateToken(token: token)
            }
        })
    }
    
    /* Validate token and go to profile */
    func validateToken(token: String) {
        APIManager.shared.callValidateAPI(token: token) { token in
            UserDefaults.standard.setValue(token, forKey: "userToken")
            DispatchQueue.main.async {
                self.coordinator.goToProfile() /* Login user. Go to profile */
            }
        }
    }
    
    /* Go to register form */
    func goToSignIn() {
        coordinator.goToRegister()
    }
    
    /* Go to forgot password view */
    func goToForgotPassword() {
        coordinator.goToForgotPassword()
    }
    
}
