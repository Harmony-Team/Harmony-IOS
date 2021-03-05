//
//  ServicesViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import SwiftyVK
import VK_ios_sdk

class ServicesViewModel {
    
    var coordinator: ServicesCoordinator!
    var user: User!
    
    /* Spotify */
    var spotifyService = SpotifyService.shared
    var spotifyUser: SpotifyUser?
    
    /* VK */
    var vkService = VKService()
    
    /* OK */
    
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
        fetchSpotifyProfile(accessToken: spotifyAccessToken)
    }
    
    func fetchSpotifyProfile(accessToken: String) {
        let tokenURLFull = "https://api.spotify.com/v1/me"
        let url = URL(string: tokenURLFull)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            let result = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            let spotifyId: String! = (result?["id"] as! String) // Spotify ID
            let spotifyDisplayName: String! = (result?["display_name"] as! String) // Spotify User Name
//            let spotifyEmail: String! = (result?["email"] as! String) // Spotify Email
//            
            self.spotifyUser = SpotifyUser(spotifyId: spotifyId, spotifyName: spotifyDisplayName, spotifyEmail: "kos@mail.ru", spotifyAccessToken: accessToken)
//            
            UserProfileCache.save(self.spotifyUser, "spotifyUser")
        }
        task.resume()
    }
    
    /* VK Auth */
    func authVK() {
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("SwiftyVK: success authorize with", info)
            },
            onError: { error in
                print("SwiftyVK: authorize failed with", error)
            }
        )
    }
    
    /* Set user services integrations IDs */
    func setIntergrationIDs() {
        let userToken = UserDefaults.standard.value(forKey: "userToken") as! String
        let serviceIntergration = ServiceIntergration(spotify: spotifyUser?.spotifyId ?? "null")
        APIManager.shared.setUserIntergrations(token: userToken, services: serviceIntergration, spotifyId: serviceIntergration.spotify) {
            self.endRegistration()
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
