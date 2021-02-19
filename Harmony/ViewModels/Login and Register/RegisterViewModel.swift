//
//  RegisterViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class RegisterViewModel {
    
    var coordinator: RegisterCoordinator!
    
    /* Register user and go to services */
    func registerUser(user: RegisterUser, completion: @escaping (Result<String?, Error>) -> Void) {
        APIManager.shared.callRegisterAPI(register: user, completion: { msg in
            if msg != "" {
                completion(.success(msg))
            } else {
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                
//                UserProfileCache.save(user, "user")
                completion(.success(nil))
                self.goToServices(with: user)
            }
        })
    }
    
    /* Username validation */
    func isValidUsername(name: String) -> Bool {
        let nameRegEx = "[A-Z0-9a-z_-]{4,}"

        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
    
    /* Email address validation */
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /* Password validation */
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "[A-Z0-9a-z._-]{8,}"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    /* Go to services */
    func goToServices(with data: Any) {
        coordinator.goToServices(with: data)
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
