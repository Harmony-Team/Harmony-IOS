//
//  AppDelegate.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var loginCoordinator: LoginCoordinator?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            let vc: MainTabBarController = .instantiate()
            window?.rootViewController = vc
            window?.makeKeyAndVisible()
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            loginCoordinator = LoginCoordinator(window: window!)
            loginCoordinator?.start()
        }
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let app = options[.sourceApplication] as? String
//        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
//        VKSdk.processOpen(url, fromApplication: sourceApplication)
//        OKSDK.open(url)
        
        return false
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

