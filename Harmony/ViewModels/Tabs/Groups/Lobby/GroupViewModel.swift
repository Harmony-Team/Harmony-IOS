//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 18.03.2021.
//

import UIKit

enum SpotifyError: Error {
    case NotSignedIn
    case NoPlaylists
}

class GroupViewModel {
    
    var coordinator: GroupCoordinator!
    
    enum Cell {
        case track(viewModel: MusicCellViewModel)
    }
    
    private(set) var cells: [Cell] = []
    
    var onUpdate = {}
    
    /* Spotify */
    var spotifyUser: SpotifyUser?
    var spotifyTracks = [Track]()
    var spotifyPlaylistList: [Playlist]?
    
    func viewDidLoad(completion: @escaping ()->()) {
        onUpdate()
        completion()
    }
    
    /* Go to selected track */
//    func goToTrack() {
//        coordinator.goToTrack()
//    }
    
    func cellForRow(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    /* Check if user is logged in Spotify */
    func checkSpotify(completionHandler: @escaping (Result<Int?, SpotifyError>) -> Void) {
        
        if SpotifyService.shared.isSignedIn {
            print("Logged in spotify")
            print(SpotifyService.shared.shouldRefreshToken)
            let semaphore = DispatchSemaphore(value: 0)
            
            spotifyUser = UserProfileCache.get(key: "spotifyUser")
            getPlaylists(for: spotifyUser!) { (playlistArr) in
                self.spotifyPlaylistList = playlistArr
                semaphore.signal()
            }
            semaphore.wait()

            guard let playlists = spotifyPlaylistList else {
                print("No Spotify Playlists")
                completionHandler(.failure(.NoPlaylists))
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
            completionHandler(.failure(.NotSignedIn))
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
                    do { semaphore.signal() }
                }
            })
        }
        
        semaphore.wait()
        return tracks
    }
    
}
