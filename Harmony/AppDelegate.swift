//
//  AppDelegate.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import VK_ios_sdk
import ok_ios_sdk

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var auth = SPTAuth()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        auth.redirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")
//        auth.sessionUserDefaultsKey = "current session"
        
        setupSpotify()
        
        return true
    }
    
    func setupSpotify() {
        let spotifyService = SpotifyService()
        SPTAuth.defaultInstance().clientID = spotifyService.clientID
        SPTAuth.defaultInstance().redirectURL = URL(string: spotifyService.redirectURI) 
        SPTAuth.defaultInstance().sessionUserDefaultsKey = spotifyService.sessionKey
        
        //For this application we just want to stream music, so we will only request the streaming scope
        SPTAuth.defaultInstance().requestedScopes = [
            SPTAuthStreamingScope,
            SPTAuthUserFollowReadScope, // Scope that lets you get a list of artists and users the authenticated user is following
            SPTAuthUserLibraryReadScope, // Scope that lets you read user’s Your Music library
            SPTAuthUserReadPrivateScope, // Scope that lets you read the private user information of the authenticated user
            SPTAuthUserReadEmailScope // Scope that lets you get the email address of the authenticated user
        ]
        
        // Start the player (this is only need for applications that using streaming, which we will use
        // in this tutorial)
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: spotifyService.clientID)
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            //Check if this URL was sent from the Spotify app or website
            if SPTAuth.defaultInstance().canHandle(url) {
                
                //Send out a notification which we can listen for in our sign in view controller
                NotificationCenter.default.post(name: NSNotification.Name.Spotify.authURLOpened, object: url)
                
                return true
            }
            
            return false
        }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        VKSdk.processOpen(url, fromApplication: sourceApplication)
        OKSDK.open(url)
//        if auth.canHandle(auth.redirectURL) {
//            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
//                if error != nil {
//                    print("error!")
//                    return
//                }
//                let userDefaults = UserDefaults.standard
//                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
//                print(sessionData)
//                userDefaults.set(sessionData, forKey: "SpotifySession")
//                userDefaults.synchronize()
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
//            })
//            return true
//        }
//
//        return false
        
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

