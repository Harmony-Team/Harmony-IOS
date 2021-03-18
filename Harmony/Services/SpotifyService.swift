//
//  SpotifyService.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class SpotifyService {
    
    var refreshingToken = false
    
    struct Constants {
        static let clientID = "afa2b19905b84b09ac9c2986b43fb072"
        static let redirectURI = "spotify-harmony-app://spotify-login-callback"
        static let secretId = "0abcafc2ee8a4cf5a845d5b349777ff4"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20playlist-read-private%20playlist-read-collaborative"
        static let tokenAPIUrl = "https://accounts.spotify.com/api/token"
        static let integrationAPIUrl = "https://harmony-db.herokuapp.com/api/user/integrate"
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
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let curDate = Date()
        let fiveMinutes: TimeInterval = 300
        return curDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    static let shared = SpotifyService()
    private init() {}
    
    public var signInUrl: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=true"
        return URL(string: string)
    }
    
    /* Exchanging authorisation code for access token */
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenAPIUrl) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.secretId
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, resp, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                
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
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.secretId
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, resp, error) in
            self?.refreshingToken = false
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
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
        
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
    
    
    /* Integration Of Spotify */
    func integrateSpotify() {

        guard let url = URL(string: Constants.integrationAPIUrl) else {
            return
        }

        var request = URLRequest(url: url)
        let token = UserDefaults.standard.string(forKey: "userToken")!

        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let spotifyUser = SpotifyUserIntegration(spotifyId: "1234", accessToken: accessToken!, refreshToken: refreshToken!)
        
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
    
    
}









/* Get user's playlists */
func getPlaylists(for user: SpotifyUser, completion: @escaping ((_ playlistList: [Playlist])->Void)) {
    let urlString = "https://api.spotify.com/v1/users/\(user.spotifyId)/playlists"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    
    var playlists: [Playlist]?
    var tracks = [Track]()
    var playlistLinks = [String]()
    var accessToken: String?
    SpotifyService.shared.withValidToken { token in
        accessToken = token
    }
    
    request.allHTTPHeaderFields = [
        "Authorization": "Bearer \(accessToken ?? "")"
    ]
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else { return }
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        
        /* Getting tracks from playlists */
        if let jsonPlaylists = try? decoder.decode(Playlists.self, from: data) {
            playlists = jsonPlaylists.items
            //            playlists?.forEach { playlist in
            //                playlistLinks.append(playlist.tracks.href)
            //                print(playlist.tracks.href)
            //                getTracks(for: user, urlString: playlist.tracks.href, completion: { (track_list) in
            //                    tracks = track_list
            //                })
            //            }
            completion(playlists ?? [])
        }
    }.resume()
    
    
}

/* Get track from playlist */
func getTracks(for user: SpotifyUser, urlString: String, completion: @escaping ((_ tracks: [Track])->Void)) {
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    var accessToken: String?
    SpotifyService.shared.withValidToken { token in
        accessToken = token
    }
    request.allHTTPHeaderFields = [
        "Authorization": "Bearer \(accessToken ?? "")"
    ]
    var tracks_list: [TrackItem]?
    var tracks = [Track]()
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else { return }
        guard let data = data else { return }
        
        let decoder = JSONDecoder()
        
        if let jsonTracks = try? decoder.decode(TracksList.self, from: data) {
            tracks_list = jsonTracks.items
            tracks_list?.forEach { cur_track in
                let track = Track(album: cur_track.track.album, artists: cur_track.track.artists, name: cur_track.track.name)
                tracks.append(track)
            }
            completion(tracks)
        }
    }
    
    task.resume()
    while task.state != .completed {
        Thread.sleep(forTimeInterval: 0.1)
    }
    //    print("! \(tracks.count)")
    
}
