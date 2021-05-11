//
//  APIManager.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    private let base_url = "https://harmony-db.herokuapp.com"
    
    // MARK: LOGIN/REGISTER
    /* Register function */
    func callRegisterAPI(register: RegisterUser, completion: @escaping (String) -> ()) {
        let registerAPI = "\(base_url)/api/signup?login=\(register.login)&password=\(register.password)&email=\(register.email)"
        let url = URL(string: registerAPI)!
        var request = URLRequest(url: url)
        
        var msg = ""
        var token = ""

        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])

                let code = (json as AnyObject).value(forKey: "code") as! Int
                
                if code > 0 {
                    msg = (json as AnyObject).value(forKey: "message") as! String
                } else {
                    token = (json as AnyObject).value(forKey: "token") as! String
                    UserDefaults.standard.setValue(token, forKey: "userToken")
                }
                completion(msg)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Creating user function */
    func callCreateAPI(registerUser: RegisterUser, token: String, completion: @escaping (User) -> ()) {
        let createAPI = "\(base_url)/api/user?login=\(registerUser.login)&password=\(registerUser.password)&email=\(registerUser.email)"
        let url = URL(string: createAPI)!
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if code == 0 {
                    let decoder = JSONDecoder()
                    let resp: UserResponse = try! decoder.decode(UserResponse.self, from: data)
                    let user = resp.response[0]
                    UserProfileCache.save(user, "user")
                    completion(user)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Login function */
    func callLoginAPI(login: LoginUser, completion: @escaping (String, String) -> ()) {
        let loginAPI = "\(base_url)/api/auth?login=\(login.username!)&password=\(login.password!)"
        let url = URL(string: loginAPI)!
        var request = URLRequest(url: url)
        
        var msg = ""
        var token = ""
 
        request.httpMethod = "POST"
        
//        let login = LoginUser(username: login.username, password: "user")
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                
                if code > 0 {
                    msg = (json as AnyObject).value(forKey: "message") as! String
                } else {
                    token = (json as AnyObject).value(forKey: "token") as! String
                }
                completion(msg, token)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
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
        
//        print(token)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                
                let resp: UserResponse = try JSONDecoder().decode(UserResponse.self, from: data)

                let user = resp.response[0]
                UserProfileCache.save(user, "user")
                completion(user)
            }
            catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    /* Integration Of Spotify */
    func integrateSpotify(accessToken: String) {
        let integrateApi = "\(base_url)/api/user/integrate"
        let url = URL(string: integrateApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let us = SpotifyUserIntegration(spotifyId: "1234", accessToken: "1234", refreshToken: "1234")
        
        let encodedData = try? JSONEncoder().encode(us)
        print(String(data: encodedData!, encoding: .utf8)!) //<- Looks as intended
        request.httpBody = encodedData
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: [])
                
                print(result)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: GROUPS
    /* Creating Group */
    func createGroup(groupName: String, groupDescr: String, avatarUrl: String, completion: @escaping (NewGroup)->()) {
        let createGroupApi = "\(base_url)/api/group/create?groupName=\(groupName)&description=\(groupDescr)&avatarUrl=\("avatarUrl")"
        let url = URL(string: createGroupApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if code == 0 {
                    let decoder = JSONDecoder()
                    let resp: NewGroup = try decoder.decode(NewGroup.self, from: data)
                    
                    completion(resp)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Getting User's Groups */
    func getGroups(completion: @escaping ([UserGroup]) -> ()) {
        let getGroupApi = "\(base_url)/api/user/groups"
        let url = URL(string: getGroupApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!
        var code = 0

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                code = (json as AnyObject).value(forKey: "code") as! Int
                if code == 0 {
                    let decoder = JSONDecoder()
                    let resp: GroupsResponse = try decoder.decode(GroupsResponse.self, from: data)
//                    print(resp.response)
                    completion(resp.response)
                    
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Getting User's Groups */
    func getGroupById(id: Int, completion: @escaping (UserGroup) -> ()) {
        let getGroupApi = "\(base_url)/api/user/groups"
        let url = URL(string: getGroupApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!
        var code = 0

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                code = (json as AnyObject).value(forKey: "code") as! Int
                if code == 0 {
                    let decoder = JSONDecoder()
                    let resp: GroupsResponse = try decoder.decode(GroupsResponse.self, from: data)
                    resp.response.forEach {
                        if $0.id == id {
                            completion($0)
                        }
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Create Invite Code */
    func createInviteCode(groupId: Int, days: Int, completion: @escaping (String) -> ()) {
        let invideCodeApi = "\(base_url)/api/group/invite?groupId=\(groupId)&days=\(days)"
        let url = URL(string: invideCodeApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let inviteCode = (json as AnyObject).value(forKey: "message") as! String
                completion(inviteCode)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Join Group By Code */
    func joinGroupByCode(code: String, completion: @escaping ((String?, NewGroup?)) -> ()) {
        let invideCodeApi = "\(base_url)/api/group/join?inviteCode=\(code)"
        let url = URL(string: invideCodeApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
                        
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if(code != 0) {
                    let msg = (json as AnyObject).value(forKey: "message") as! String
                    completion((msg, nil))
                } else {
                    let decoder = JSONDecoder()
                    let resp: NewGroup = try decoder.decode(NewGroup.self, from: data)
                    completion((nil, resp))
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Add Song In Pull */
    func addSong(groupId: Int, spotifyId: String, songName: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let addSongApi = "\(base_url)/api/group/music/add?groupId=\(groupId)&spotifyId=\(spotifyId)"
        let url = URL(string: addSongApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if(code != 0) {
                    completion(.success("Somebody in this lobby has already added song '\(songName)' in pull.\n Add another song please."))
                } else {
                    print("Song '\(songName)' was added.(\(spotifyId)")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Remove Song From Pull */
    func removeSong(groupId: Int, spotifyId: String, songName: String) {
        let removeSongApi = "\(base_url)/api/group/music/remove?groupId=\(groupId)&spotifyId=\(spotifyId)"
        let url = URL(string: removeSongApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if(code == 0) {
                    print("Song '\(songName)' was removed.")
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /* Get All Pull Songs */
    func getSongs(groupId: Int, userLogin: String, completion: @escaping (([PullTrack], Int)) -> ()) {
        let getSongApi = "\(base_url)/api/group/music/get?groupId=\(groupId)"
        let url = URL(string: getSongApi)!
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!
        var tracksInPull = [PullTrack]()
        var tracksCount = 0

        request.allHTTPHeaderFields = [
            "Authorization": "\(token)"
        ]
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let code = (json as AnyObject).value(forKey: "code") as! Int
                if code == 0 {
                    let decoder = JSONDecoder()
                    let resp: PullTrackResponse = try decoder.decode(PullTrackResponse.self, from: data)
                    
                    tracksCount = resp.response.count
                    
                    tracksInPull = resp.response.filter(){$0.userLogin == userLogin}
                    completion((tracksInPull, tracksCount))
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
