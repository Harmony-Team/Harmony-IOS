//
//  LoginViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit
import SafariServices
import AVFoundation

class LoginViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    var viewModel: LoginViewModel!
    
    /* Spotify */
    var auth = SPTAuth.defaultInstance()
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    @IBOutlet weak var userNameTextField: LoginTextFieldStyle!
    @IBOutlet weak var passwordTextField: LoginTextFieldStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        passwordTextField.isSecureTextEntry = true
        setupPasswordEye()
    }
    
    func setup() {
        let redirectUrl = "spotify-ios-quick-start://spotify-login-callback"
        let cliendID = "afa2b19905b84b09ac9c2986b43fb072"
        auth?.redirectURL = URL(string: redirectUrl)
        auth?.clientID = cliendID
        auth?.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth?.spotifyAppAuthenticationURL()
    }
    
    private func setupPasswordEye() {
        let eyeButton = UIButton()
        eyeButton.setImage(UIImage(named: "eye"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        eyeButton.addTarget(self, action: #selector(togglePasswordText), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .whileEditing
    }
    
    @objc private func togglePasswordText() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    //    @objc func updateAfterFirstLogin () {
    //        let userDefaults = UserDefaults.standard
    //        if let sessionObj: AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
    //            let sessionDataObj = sessionObj as! Data
    //            let firstTimeSession = NSKeyedUnarchiver.unarchivedObject(with: sessionDataObj) as! SPTSession
    //            self.session = firstTimeSession
    //        }
    //    }
    
    @IBAction func loginWithSpotify(_ sender: UIButton) {
    }
    
    /* Go to register form */
    @IBAction func goToSignIn(_ sender: UIButton) {
        viewModel.goToSignIn()
    }
    
    /* Go to forgot password view */
    @IBAction func goToForgotPassword(_ sender: UIButton) {
        viewModel.goToForgotPassword()
    }
}
