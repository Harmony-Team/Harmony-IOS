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
    
    // MARK: - LOGIN
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
}

// MARK: - REGISTER
extension LoginViewModel {
    /* Register user and go to services */
    func registerUser(user: RegisterUser, completion: @escaping (Result<String?, Error>) -> Void) {
        APIManager.shared.callRegisterAPI(register: user, completion: { msg in
            if msg != "" {
                completion(.success(msg))
            } else {
                UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
                self.createUser(registerUser: user)
                completion(.success(nil))
            }
        })
    }
    
    /* Create User */
    func createUser(registerUser: RegisterUser) {
        let token = UserDefaults.standard.value(forKey: "userToken") as! String
        APIManager.shared.callCreateAPI(registerUser: registerUser, token: token, completion: { user in
            DispatchQueue.main.async {
                self.goToServices(with: user)
            }
        })
    }
    
    /* Username validation */
    func isValidUsername(name: String) -> Bool {
        let nameRegEx = "[A-Z0-9a-z_-]{4,}"

        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    }
    
    /* Email address validation */
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /* Password validation */
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "[A-Z0-9a-z._-]{8,}"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    /* Go to services */
    func goToServices(with data: Any) {
        coordinator.goToServices(with: data)
    }
    
//    func viewDidDisappear() {
//        coordinator.goBack()
//    }
}
