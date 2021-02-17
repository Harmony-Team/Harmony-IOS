//
//  SettingsViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

class SettingsViewModel {
    
    var coordinator: SettingsCoordinator!
    var user: User!
    var userInfoDictionary: [String: String]!
    
    func getUserInfoDictionary() {
        userInfoDictionary = [
            "Username": user.username,
            "Email": user.email,
            "Password": "********"
        ]
    }
    
    /* Logout and go to login form */
    func logout() {
//        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        coordinator.goToLogin()
    }
    
}
