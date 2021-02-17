//
//  ServicesViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import SafariServices
import VK_ios_sdk
import ok_ios_sdk
import WebKit
import Alamofire

class ServicesViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    var viewModel: ServicesViewModel!
    
    /* Spotify */
    var spotifyService = SpotifyService()
    var spotifyUser: SpotifyUser?
    
    /* VK */
    let vk_app_id = "7750806"
    var sdkInstance: VKSdk?
    var scope = ["email", "photos", "offline"]
    
    /* OK */
    var okScope = ["VALUABLE_ACCESS", "LONG_ACCESS_TOKEN", "PHOTO_CONTENT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkInstance = VKSdk.initialize(withAppId: vk_app_id)
    }
    
    /* Spotify Authorization */
    @IBAction func spotifySignUp(_ sender: UIButton) {
        spotifyAuthVC()
    }
    
    var webView: UIWebView!
    func spotifyAuthVC() {
        // Create Spotify Auth ViewController
        let spotifyVC = UIViewController()
        // Create WebView
        webView = UIWebView()
        webView?.delegate = self
        spotifyVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: spotifyVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: spotifyVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: spotifyVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: spotifyVC.view.trailingAnchor)
        ])
        
//        let authURLFull = "https://accounts.spotify.com/authorize?client_id=\(spotifyService.clientID)&response_type=code&redirect_uri=\(spotifyService.redirectURI)&scope=\(spotifyService.scopes)"
        
        let authURLFull = "https://accounts.spotify.com/authorize?response_type=token&client_id=\(spotifyService.clientID)&scope=\(spotifyService.scopes)&redirect_uri=\(spotifyService.redirectURI)&show_dialog=false"
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        print(urlRequest)
        webView.loadRequest(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: spotifyVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        spotifyVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        spotifyVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        spotifyVC.navigationItem.title = "spotify.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = .white
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    /* VK Authorization */
    @IBAction func vkSignUp(_ sender: UIButton) {
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == .authorized {
                print("User authorized")
            } else {
                VKSdk.authorize(self.scope)
            }
            return
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(result)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Auth failed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("VK Should present")
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("Show captcha")
    }
    
    /* OK Authorization */
    @IBAction func okSignUp(_ sender: UIButton) {
        OKSDK.authorize(withPermissions: okScope) { data in
            print(data)
        } error: { error in
            print(error)
        }
        
    }
    
    /* End registration. Go to profile */
    @IBAction func endRegistration(_ sender: UIButton) {
        viewModel.endRegistration()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}

extension ServicesViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        //        spotifyService.RequestForCallbackURL(request: request)
        requestForCallbackURL(request: request)
        return true
    }
    
    
    func requestForCallbackURL(request: URLRequest) {
        // Get the access token string after the '#access_token=' and before '&token_type='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(spotifyService.redirectURI) {
            print(requestURLString)
            if requestURLString.contains("#access_token=") {
                if let range = requestURLString.range(of: "=") {
                    let spotifAcTok = requestURLString[range.upperBound...]
                    if let range = spotifAcTok.range(of: "&token_type=") {
                        let spotifAcTokFinal = spotifAcTok[..<range.lowerBound]
                        handleAuth(spotifyAccessToken: String(spotifAcTokFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(spotifyAccessToken: String) {
        fetchSpotifyProfile(accessToken: spotifyAccessToken)
        
        self.dismiss(animated: true, completion: nil)
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
                
                //Spotify Profile Avatar URL
                //                let spotifyAvatarURL: String!
                //                let spotifyProfilePicArray = result?["images"] as? [AnyObject]
                //                if (spotifyProfilePicArray?.count)! > 0 {
                //                    spotifyAvatarURL = spotifyProfilePicArray![0]["url"] as? String
                //                } else {
                //                    spotifyAvatarURL = "Not exists"
                //                }
                
//                print(accessToken)
                
                self.spotifyUser = SpotifyUser(spotifyId: spotifyId, spotifyName: spotifyDisplayName, spotifyEmail: spotifyEmail, spotifyAccessToken: accessToken)
                
                UserProfileCache.save(self.spotifyUser, "spotifyUser")
                UserDefaults.standard.setValue(true, forKey: "isLoggedSpotify")
                
            }
        }
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //fetch Spotify access token. Use after getting responseTypeCode
//    func fetchSpotifyToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
//        
//        let url = URL(string: "https://accounts.spotify.com/api/token")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        let spotifyAuthKey = "Basic \((spotifyService.clientID + ":" + spotifyService.secretId).data(using: .utf8)!.base64EncodedString())"
//        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey, "Content-Type": "application/x-www-form-urlencoded"]
//        
//        do {
//            var requestBodyComponents = URLComponents()
//            let scopeAsString = stringScopes.joined(separator: " ") //put array to string separated by whitespace
//            requestBodyComponents.queryItems = [URLQueryItem(name: "client_id", value: spotifyService.clientID), URLQueryItem(name: "grant_type", value: "authorization_code"), URLQueryItem(name: "code", value: responseTypeCode!), URLQueryItem(name: "redirect_uri", value: spotifyService.redirectURI), URLQueryItem(name: "code_verifier", value: codeVerifier), URLQueryItem(name: "scope", value: scopeAsString),]
//            request.httpBody = requestBodyComponents.query?.data(using: .utf8)
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data,                            // is there data
//                      let response = response as? HTTPURLResponse,  // is there HTTP response
//                      (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
//                      error == nil else {                           // was there no error, otherwise ...
//                    print("Error fetching token \(error?.localizedDescription ?? "")")
//                    return completion(nil, error)
//                }
//                let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//                print("Access Token Dictionary=", responseObject ?? "")
//                completion(responseObject, nil)
//            }
//            
//            task.resume()
//        } catch {
//            print("Error JSON serialization \(error.localizedDescription)")
//        }
//    }
    
}
