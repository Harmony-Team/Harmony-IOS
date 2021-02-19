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
    var spotifyService = SpotifyService()
    var spotifyUser: SpotifyUser?
    
    /* VK */
    var vkService = VKService()
    
    /* OK */
    
    /* Spotify Auth */
    func requestForCallbackURL(request: URLRequest, completion: @escaping ()->()) {
        // Get the access token string after the '#access_token=' and before '&token_type='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(spotifyService.redirectURI) {
            if requestURLString.contains("#access_token=") {
                if let range = requestURLString.range(of: "=") {
                    let spotifAcTok = requestURLString[range.upperBound...]
                    if let range = spotifAcTok.range(of: "&token_type=") {
                        let spotifAcTokFinal = spotifAcTok[..<range.lowerBound]
                        handleAuth(spotifyAccessToken: String(spotifAcTokFinal))
                        completion()
                    }
                }
            }
        }
    }
    
    func handleAuth(spotifyAccessToken: String) {
        fetchSpotifyProfile(accessToken: spotifyAccessToken)
    }
    
    func fetchSpotifyProfile(accessToken: String) {
        let tokenURLFull = "https://api.spotify.com/v1/me"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let spotifyId: String! = (result?["id"] as! String) // Spotify ID
                let spotifyDisplayName: String! = (result?["display_name"] as! String) // Spotify User Name
                let spotifyEmail: String! = (result?["email"] as! String) // Spotify Email
                
                self.spotifyUser = SpotifyUser(spotifyId: spotifyId, spotifyName: spotifyDisplayName, spotifyEmail: spotifyEmail, spotifyAccessToken: accessToken)
                
                UserProfileCache.save(self.spotifyUser, "spotifyUser")
                UserDefaults.standard.setValue(true, forKey: "isLoggedSpotify")
            }
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
    
    /* Register user. Go to profile */
    func endRegistration() {
        coordinator.goToProfile()
    }
    
    func viewDidDisappear() {
        coordinator.goBack()
    }
    
}
