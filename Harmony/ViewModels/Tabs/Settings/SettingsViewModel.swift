//
//  SettingsViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit
import CoreData

class SettingsViewModel {
    
    // Menu
    var menuShow = false
    
    var coordinator: SettingsCoordinator!
    var user: User!
    var userInfoDictionary: [String: String]!
    
    /* Spotify */
    var spotifyService = SpotifyService.shared
    var apiManager = APIManager.shared
    
    func getUserInfoDictionary() {
        
        if let user: User = UserProfileCache.get(key: "user") {
            self.user = user
        }
        
        let userEmail = user.email
        
        userInfoDictionary = [
            "Email": userEmail,
            "Password": "********"
        ]
        
    }
    
    func goToEditCell() {
        coordinator.goToEditScreen()
    }
    
    /* Spotify Auth */
    func requestForCallbackURL(request: URLRequest, completion: @escaping ()->()) {
        
        // Exchange code for access token
        let requestURLString = (request.url?.absoluteString)! as String
        
        // Getting code
        let component = URLComponents(string: requestURLString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        
        // Exchanging code for token
        spotifyService.exchangeCodeForToken(code: code) { [weak self] success in
            self?.spotifyService.withValidToken { token in
                self?.handleAuth(spotifyAccessToken: token)
                DispatchQueue.main.async {
                   completion()
                }
            }
        }
    }
    
    func handleAuth(spotifyAccessToken: String) {
        spotifyService.fetchSpotifyProfile(accessToken: spotifyAccessToken) { spotifyUser in
            self.apiManager.integrateSpotify(accessToken: spotifyAccessToken)
        }
    }
    
    /* Spotify Logout */
    func handleLogout() {
        UserDefaults.standard.removeObject(forKey: "spotifyUser")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
        TracksCoreDataManager.shared.deleteTracks()
        spotifyService.disintegrateSpotify()
    }
    
    /* Logout and go to login form */
    func logout() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "spotifyUser")
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")

        coordinator.goToLogin()
    }
    
    /* Go To Selected Section */
    func goToSelectedSection(section: MenuSection) {
        coordinator.goToSection(section: section)
    }
    
    /* Go back to profile */
    func viewDidDisappear() {
        coordinator.goToProfile()
    }
    
}
