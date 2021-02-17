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
    func callRegisterAPI(register: User, completion: @escaping (String) -> ()) {
        
        var code = 0
        var msg = ""
        
        let registerAPI = "https://harmony-db.herokuapp.com/api/user?login=\(register.username)&password=\(register.password)&email=\(register.email)"
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
    func callLoginAPI(login: LoginUser) {
        let loginAPI = "https://harmony-db.herokuapp.com/api/user?login=\(login.username!)"
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        let login = LoginUser(username: login.username, password: "user")

        AF.request(loginAPI,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
        }
        
//        AF.request(loginAPI, method: .get, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
//
//                    print(json)
////                    code = (json as AnyObject).value(forKey: "code") as! Int
////                    if code > 0 {
////                        msg = (json as AnyObject).value(forKey: "message") as! String
////                    }
////                    completion(msg)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
        
    }
    
}
