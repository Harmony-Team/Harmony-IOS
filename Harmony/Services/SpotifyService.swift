//
//  SpotifyService.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import CoreData
import CommonCrypto

class SpotifyService {
    
    private var refreshingToken = false
    
    private struct Constants {
        static let clientID = "afa2b19905b84b09ac9c2986b43fb072"
        static let redirectURI = "spotify-harmony-app://spotify-login-callback"
        static let scopes = "user-read-private%20user-read-email%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20playlist-read-collaborative"
        static let tokenAPIUrl = "https://accounts.spotify.com/api/token"
        static let spotifyUserAPIUrl = "https://api.spotify.com/v1/me"
        static let integrationAPIUrl = "https://harmony-db.herokuapp.com/api/user/integrate"
        static let disintegrationAPIUrl = "https://harmony-db.herokuapp.com/api/user/disintegrate"
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var codeVerifier: String!
    
    private var codeChallenge: String!
    
    var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let curDate = Date()
        let fiveMinutes: TimeInterval = 300
        return curDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    static let shared = SpotifyService()
    private init() {}
    
    /* Spotify SignIn URL Link */
    public var signInUrl: URL? {
        codeVerifier = getCodeVerifier()
        codeChallenge = getCodeChallenge(codeVerifier: codeVerifier)
        
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&code_challenge=\(codeChallenge ?? "")&code_challenge_method=S256&show_dialog=true"
        return URL(string: string)
    }
    
    /* Exchanging authorisation code for access token */
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenAPIUrl) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code_verifier", value: codeVerifier)
        ]
        
//        print("Code Verifier: \(codeVerifier ?? "")")
//        print("Code Challenge(Base64URL): \(codeVerifier ?? "")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                print(result)
                self?.cacheToken(result: result)
                
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private var onRefreshBlocks = [(String) -> Void]()
    
    /* Get Access Token */
    public func withValidToken(completion: @escaping ((String) -> Void)) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshTokenIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    /* Refresh access token */
    public func refreshTokenIfNeeded(completion: @escaping ((Bool) -> Void)) {
        guard !refreshingToken else { return }
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            return
        }
        
        // Refreshing token
        guard let url = URL(string: Constants.tokenAPIUrl) else {
            return
        }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: Constants.clientID)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, resp, error) in
            self?.refreshingToken = false
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let res = try JSONSerialization.jsonObject(with: data, options: [])
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                print(res)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                print("Token was refreshed!")
                self?.cacheToken(result: result)
                
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    /* Saving user's token */
    private func cacheToken(result: SpotifyAuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        var spotifyUser: SpotifyUser? = UserProfileCache.get(key: "spotifyUser")
        spotifyUser?.spotifyAccessToken = result.access_token
        UserProfileCache.save(spotifyUser, "spotifyUser")
        
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    /* Return Code Verifier */
    private func getCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 64)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let codeVerifier = Data(_: buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return codeVerifier
    }
    
    /* Return Code Challenge */
    private func getCodeChallenge(codeVerifier: String) -> String {
        guard let verifierData = codeVerifier.data(using: String.Encoding.utf8) else { return "error" }
        var buffer = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
        
        let _ = verifierData.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(verifierData.count), &buffer)
        }
        let hash = Data(_: buffer)
        
        let challenge = hash.base64EncodedData()
        return String(decoding: challenge, as: UTF8.self)
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
    
    /* Get Spotify User Info + Saving Spotify User */
    func fetchSpotifyProfile(accessToken: String, completion: @escaping ((SpotifyUser) -> ())) {
        guard let url = URL(string: Constants.spotifyUserAPIUrl) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            let result = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            
            let spotifyId: String! = (result?["id"] as! String) // Spotify ID
            let spotifyDisplayName: String! = (result?["display_name"] as! String) // Spotify User Name
            let spotifyEmail: String! = (result?["email"] as! String) // Spotify Email
            
            // Create New Spotify User
            let spotifyUser = SpotifyUser(spotifyId: spotifyId, spotifyName: spotifyDisplayName, spotifyEmail: spotifyEmail, spotifyAccessToken: accessToken)
            
            // Save Spotify User
            UserProfileCache.save(spotifyUser, "spotifyUser")
            completion(spotifyUser)
        }
        task.resume()
    }
    
    /* Integration Of Spotify */
    func integrateSpotify(spotifyId: String) {
        
        guard let url = URL(string: Constants.integrationAPIUrl) else {
            return
        }
        
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!
        
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let spotifyUser = SpotifyUserIntegration(spotifyId: spotifyId, accessToken: accessToken!, refreshToken: refreshToken!)
        
        let encodedData = try? JSONEncoder().encode(spotifyUser)
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
    
    /* Disintegration Of Spotify */
    func disintegrateSpotify() {
        
        guard let url = URL(string: Constants.disintegrationAPIUrl) else {
            return
        }
        
        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!
        
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
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
    
    
    /* Get user's playlists */
    func getPlaylists(for user: SpotifyUser, completion: @escaping ((_ playlistList: [Playlist]?)->Void)) {
        let urlString = "https://api.spotify.com/v1/users/\(user.spotifyId)/playlists"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        var playlists: [Playlist]?

        SpotifyService.shared.withValidToken { token in

            print("Getting Playlist...")

            request.allHTTPHeaderFields = [
                "Authorization": "Bearer \(token)"
            ]
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { return }
                guard let data = data else { return }
                
                let decoder = JSONDecoder()
                
                /* Getting tracks from playlists */
                if let jsonPlaylists = try? decoder.decode(Playlists.self, from: data) {
                    playlists = jsonPlaylists.items
                    completion(playlists)
                } else {
                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
            }
            
            task.resume()
        }
        
    }

    /* Get track from playlist */
    func getTracks(for user: SpotifyUser, urlString: String, completion: @escaping ((_ tracks: [SpotifyTrack])->Void)) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        let accessToken = user.spotifyAccessToken

        request.allHTTPHeaderFields = [
            "Authorization": "Bearer \(accessToken)"
        ]
        var tracks_list: [TrackItem]?
        var tracks = [SpotifyTrack]()
        
        print("Getting tracks...")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            if let jsonTracks = try? decoder.decode(TracksList.self, from: data) {
                tracks_list = jsonTracks.items
                tracks_list?.forEach { cur_track in
                    let track = Track(album: cur_track.track.album, artists: cur_track.track.artists, name: cur_track.track.name, id: cur_track.track.id)
                    guard let spotifyTrack = CoreDataManagerr.shared.saveTrack(track: track) else {
                        return
                    }
                    tracks.append(spotifyTrack)
                    
                }
                semaphore.signal()
                completion(tracks)
            }
        }
        
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        
    }

}
