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
//            "Username": user.login,
            "Email": user.email,
//            "Registration Date": user.dateCreated,
//            "Role": user.role.rawValue,
//            "Spotify": user.spotifyId ?? "",
            "Password": "********"
        ]
    }
    
    /* Logout and go to login form */
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "user")
        coordinator.goToLogin()
    }
    
    /* Go back to profile */
    func viewDidDisappear() {
        coordinator.goToProfile()
    }
    
}
