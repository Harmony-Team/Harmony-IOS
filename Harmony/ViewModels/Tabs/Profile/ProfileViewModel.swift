//
//  ProfileViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class ProfileViewModel {
    
    var coordinator: ProfileCoordinator!
    var user: User!
    var spotifyUser: SpotifyUser?
    var spotifyService = SpotifyService()
    
    /* Get user info from UserDefaults */
    func getUserInfo() {
        user = UserProfileCache.get(key: "user")
    }
    
    /* Check if user is logged in Spotify */
    func checkSpotify() {
        
//        if UserDefaults.standard.bool(forKey: "isLoggedSpotify") {
//            print("Logged")
//            spotifyUser = UserProfileCache.get(key: "spotifyUser")
//            getPlaylists(for: spotifyUser!)
//            print(spotifyUser?.spotifyAccessToken)
//        } else {
//            print("Not logged")
//        }
        
    }
    
    /* Go to user settings */
    func goToSettings() {
        coordinator.goToSettings(for: user)
    }
    
}
