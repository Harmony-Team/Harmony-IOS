//
//  SpotifyService.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class SpotifyService {
    let clientID = "afa2b19905b84b09ac9c2986b43fb072"
    let redirectURI = "spotify-harmony-app://spotify-login-callback"
    let sessionKey = "spotifySessionKey"
    let secretId = "0abcafc2ee8a4cf5a845d5b349777ff4"
    let scopes = "playlist-read-collaborative"
}

/* Get user's playlists */
func getPlaylists(for user: SpotifyUser, completion: @escaping ((_ playlistList: [Playlist])->Void)) {
    let urlString = "https://api.spotify.com/v1/users/\(user.spotifyId)/playlists"
    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    
    var playlists: [Playlist]?
    var tracks = [Track]()
    var playlistLinks = [String]()
    
    request.allHTTPHeaderFields = [
        "Authorization": "Bearer \(user.spotifyAccessToken)"
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
    request.allHTTPHeaderFields = [
        "Authorization": "Bearer \(user.spotifyAccessToken)"
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
