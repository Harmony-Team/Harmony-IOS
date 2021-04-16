//
//  GroupViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 18.03.2021.
//

import UIKit
import CoreData

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
    
    /* Group Info */
    var group: UserGroup!
    
    /* Spotify */
    private var spotifyService = SpotifyService.shared
    private var spotifyUser: SpotifyUser?
    var spotifyTracks = [SpotifyTrack]()
    var visibleSpotifyTracks = [SpotifyTrack]() // Tracks Visible In Table View
    var selectedSpotifyTracks = [SpotifyTrack]() // Selected Tracks
    private var spotifyPlaylistList: [Playlist]?
    
    func viewDidLoad() {
        print(group)
    }
    
    func reload() {
        self.selectedSpotifyTracks = coordinator.selectedSpotifyTracks
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MusicTableReload"), object: nil)
    }
    
    /* Create New Playlist */
    func createPlaylist() {
        coordinator.createNewPlaylist()
    }
    
    /* Open Search Music View Controller */
    func goToSearchMusic() {
        coordinator.goToMusicSearching(spotifyTracks: spotifyTracks, selectedSpotifyTracks: selectedSpotifyTracks)
    }
    
    func cellForRow(at indexPath: IndexPath) -> Cell {
        return cells[indexPath.row]
    }
    
    /* Check if user is logged in Spotify */
    func checkSpotify(refresh: Bool, completionHandler: @escaping (Result<Int?, SpotifyError>) -> Void) {
        if spotifyService.isSignedIn {
            print("Logged in spotify")
            print(SpotifyService.shared.shouldRefreshToken)
            let semaphore = DispatchSemaphore(value: 0)
            
            spotifyUser = UserProfileCache.get(key: "spotifyUser")
            
            let count = CoreDataManagerr.shared.fetchTracks()
            
            if count.count == 0 || SpotifyService.shared.shouldRefreshToken || refresh {
                
                CoreDataManagerr.shared.deleteTracks()
                spotifyService.getPlaylists(for: spotifyUser!) { (playlistArr) in
                    self.spotifyPlaylistList = playlistArr
                    semaphore.signal()
                }
                semaphore.wait()

                guard let playlists = spotifyPlaylistList else {
                    print("No Spotify Playlists")
                    completionHandler(.failure(.NoPlaylists))
                    return
                }
                
                spotifyUser = UserProfileCache.get(key: "spotifyUser")

                // Getting spotify tracks
                getTrackList(playlists: playlists, completionHandler: { tracks in
                    self.spotifyTracks = tracks
                })
                visibleSpotifyTracks = spotifyTracks
                cells = spotifyTracks.map {
                    let trackCellViewModel = MusicCellViewModel(track: $0)
                    return .track(viewModel: trackCellViewModel)
                }
            } else {
                spotifyTracks = CoreDataManagerr.shared.fetchTracks()
                visibleSpotifyTracks = spotifyTracks
                cells = visibleSpotifyTracks.map {
                    let trackCellViewModel = MusicCellViewModel(track: $0)
                    return .track(viewModel: trackCellViewModel)
                }
            }

            completionHandler(.success(nil))
        } else {
            print("Not logged")
            completionHandler(.failure(.NotSignedIn))
        }
    }
    
    /* Get Spotify Track List */
    private func getTrackList(playlists: [Playlist], completionHandler: @escaping ((_ tracks: [SpotifyTrack])->Void)) {
        var tracks = [SpotifyTrack]()
        let semaphore = DispatchSemaphore(value: 0)
        for (index, playlist) in playlists.enumerated() {
            spotifyService.getTracks(for: spotifyUser!, urlString: playlist.tracks.href, completion: { (track_list) in
                
                tracks += track_list
                
                if index == playlists.endIndex - 1 {
                    do { semaphore.signal() }
                    
                }
            })
        }
        
        semaphore.wait()
            completionHandler(tracks)
    }
    
}
