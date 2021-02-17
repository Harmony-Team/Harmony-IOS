//
//  MusicViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

class MusicViewModel {
    
    var coordinator: MusicCoordinator!
    
    enum Cell {
        case track(viewModel: MusicCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
    
    var onUpdate = {}
    
    /* Spotify */
    var spotifyUser: SpotifyUser?
    var spotifyTracks = [Track]()
    var spotifyPlaylistList: [Playlist]?
    
    func viewDidLoad() {
//        let view = UIView()
//        ViewControllerUtils().showActivityIndicator(uiView: view)
        checkSpotify()
//        ViewControllerUtils().hideActivityIndicator(uiView: view)
//        reload()
    }
    
    func reload() {
        cells = spotifyTracks.map {
            let trackCellViewModel = MusicCellViewModel(track: $0)
            return .track(viewModel: trackCellViewModel)
        }
        onUpdate()
    }
    
    func cellForRow(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    /* Check if user is logged in Spotify */
    func checkSpotify() {
        
        if UserDefaults.standard.bool(forKey: "isLoggedSpotify") {
            print("Logged")
            
            let semaphore = DispatchSemaphore(value: 0)
            
            spotifyUser = UserProfileCache.get(key: "spotifyUser")
            getPlaylists(for: spotifyUser!) { (playlistArr) in
                self.spotifyPlaylistList = playlistArr
                semaphore.signal()
            }
            semaphore.wait()
            
            guard let playlists = spotifyPlaylistList else {
                print("No Spotify Playlists")
                return
            }
            
            // Getting spotify tracks
            spotifyTracks = getTrackList(playlists: playlists)
            cells = spotifyTracks.map {
                let trackCellViewModel = MusicCellViewModel(track: $0)
                return .track(viewModel: trackCellViewModel)
            }
        } else {
            print("Not logged")
        }
    }
    
    /* Get Spotify Track List */
    private func getTrackList(playlists: [Playlist]) -> [Track] {
        var tracks = [Track]()
        let semaphore = DispatchSemaphore(value: 0)
        
        for (index, playlist) in playlists.enumerated() {
            getTracks(for: spotifyUser!, urlString: playlist.tracks.href, completion: { (track_list) in
                tracks += track_list
                if index == playlists.endIndex - 1 {
                    semaphore.signal()
                }
            })
        }
        
        semaphore.wait()
        return tracks
    }
    
}
