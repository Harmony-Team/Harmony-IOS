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
    
    /* Register function */
    func callRegisterAPI(register: RegisterUser, completion: @escaping (String) -> ()) {
        
        var code = 0
        var msg = ""
        var token = ""
        
        let registerAPI = "https://harmony-db.herokuapp.com/api/signup?login=\(register.login)&password=\(register.password)&email=\(register.email)"
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
    
    /* Login function */
    func callLoginAPI(login: LoginUser, completion: @escaping (String) -> ()) {
        
        var code = 0
        var msg = ""
        
        let loginAPI = "https://harmony-db.herokuapp.com/api/auth?login=\(login.username!)&password=\(login.password!)"
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
                        msg = (json as AnyObject).value(forKey: "message") as! String
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
    
    /* Get user function */
    func getUserAPI(token: String, completion: @escaping (User)->()) {
        
        let userAPI = "https://harmony-db.herokuapp.com/api/user"
        let url = URL(string: userAPI)!
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        
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
    
}
