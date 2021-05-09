//
//  ServicesViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class ServicesViewModel {
    
    var coordinator: ServicesCoordinator!
    var user: User!
    
    /* Spotify */
    var spotifyService = SpotifyService.shared
    var apiManager = APIManager.shared
    var spotifyUser: SpotifyUser?
    
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

    /* Register user. Go to profile */
    func endRegistration() {
        coordinator.goToProfile()
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
