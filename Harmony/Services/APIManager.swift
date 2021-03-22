//
//  APIManager.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    private let base_url = "https://harmony-db.herokuapp.com"
    
    /* Register function */
    func callRegisterAPI(register: RegisterUser, completion: @escaping (String) -> ()) {
        
        var code = 0
        var msg = ""
        var token = ""
        
        let registerAPI = "\(base_url)/api/signup?login=\(register.login)&password=\(register.password)&email=\(register.email)"
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(registerAPI, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(json)
                    code = (json as AnyObject).value(forKey: "code") as! Int
                    if code > 0 {
                        msg = (json as AnyObject).value(forKey: "message") as! String
                    } else {
                        token = (json as AnyObject).value(forKey: "token") as! String
                        UserDefaults.standard.setValue(token, forKey: "userToken")
                    }
                    completion(msg)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /* Creating user function */
    func callCreateAPI(registerUser: RegisterUser, token: String, completion: @escaping (User) -> ()) {

        var code = 0
        
        let createAPI = "\(base_url)/api/user?login=\(registerUser.login)&password=\(registerUser.password)&email=\(registerUser.email)"
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        
        print(token)
        
        AF.request(createAPI, method: .post, parameters: registerUser, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(json)
                    code = (json as AnyObject).value(forKey: "code") as! Int
                    if code == 0 {
                        let decoder = JSONDecoder()
                        let resp: UserResponse = try! decoder.decode(UserResponse.self, from: data!)
//                        guard let resp: UserResponse = (json as AnyObject).value(forKey: "response") as? UserResponse else {return}
                        let user = resp.response[0]
                        UserProfileCache.save(user, "user")
                        completion(user)
                    }
//                    completion(msg)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /* Login function */
    func callLoginAPI(login: LoginUser, completion: @escaping (String, String) -> ()) {
        
        var code = 0
        var msg = ""
        var token = ""
        
        let loginAPI = "\(base_url)/api/auth?login=\(login.username!)&password=\(login.password!)"
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let login = LoginUser(username: login.username, password: "user")
        
        AF.request(loginAPI, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(json)
                    code = (json as AnyObject).value(forKey: "code") as! Int
                    if code > 0 {
                       // msg = (json as AnyObject).value(forKey: "message") as! String
                        msg = "ssss"
                    } else {
                        token = (json as AnyObject).value(forKey: "token") as! String
                    }
                    completion(msg, token)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
    
    /* Token Validation function */
    func callValidateAPI(token: String, completion: @escaping (String) -> ()) {
        
        let userAPI = "\(base_url)/api/validate"
        let url = URL(string: userAPI)!
        var request = URLRequest(url: url)
        var userToken = ""
        
        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        print(token)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                userToken = (json as AnyObject).value(forKey: "token") as! String
                completion(userToken)
            }
            catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    /* Get user function */
    func getUserAPI(token: String, completion: @escaping (User)->()) {
        
        let userAPI = "\(base_url)/api/user"
        let url = URL(string: userAPI)!
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        print(token)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                let resp: UserResponse = try! JSONDecoder().decode(UserResponse.self, from: data)

                let user = resp.response[0]
                UserProfileCache.save(user, "user")
                completion(user)
            }
            catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    /* Set user services integrations */
    func setUserIntergrations(token: String, services: ServiceIntergration, spotifyId: String, completion: @escaping ()->()) {
        
        let servicesAPI = "\(base_url)/api/user/integrate?spotify=\(spotifyId)&vk&ok"
        
        let headers: HTTPHeaders = [
            "Authorization": "\(token)"
        ]
        
        AF.request(servicesAPI, method: .post, parameters: services, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    print(json)
//                    code = (json as AnyObject).value(forKey: "code") as! Int
//                    if code > 0 {
//                        msg = (json as AnyObject).value(forKey: "message") as! String
//                    } else {
//                        token = (json as AnyObject).value(forKey: "token") as! String
//                        UserDefaults.standard.setValue(token, forKey: "userToken")
//                    }
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
}
