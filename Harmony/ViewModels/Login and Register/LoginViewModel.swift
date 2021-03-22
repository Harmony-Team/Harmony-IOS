//
//  LoginViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class LoginViewModel {
    
    var coordinator: LoginCoordinator!
    
    /* Spotify */
    var spotifyService = SpotifyService.shared
    var spotifyUser: SpotifyUser?
    
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
            print(spotifyUser)
        }
    }
    
    /* Set user services integrations IDs */
//    func setIntergrationIDs() {
//        let userToken = UserDefaults.standard.value(forKey: "userToken") as! String
//        let serviceIntergration = ServiceIntergration(spotify: spotifyUser?.spotifyId ?? "null")
//        APIManager.shared.setUserIntergrations(token: userToken, services: serviceIntergration, spotifyId: serviceIntergration.spotify) {
//            self.endRegistration()
//        }
//    }
    
}
