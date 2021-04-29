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
    
    /* Tracks Info (Spotify) */
    private var ApiManager = APIManager.shared
    private var spotifyService = SpotifyService.shared
    private var spotifyUser: SpotifyUser?
    var spotifyTracks = [SpotifyTrack]()
    var visibleSpotifyTracks = [SpotifyTrack]() // Tracks Visible In Table View
    var selectedSpotifyTracks = [SpotifyTrack]() // Selected Tracks
    private var spotifyPlaylistList: [Playlist]?
    
    /* Playlists Info */
    
    func reload() {
        self.selectedSpotifyTracks = coordinator.selectedSpotifyTracks
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MusicTableReload"), object: nil)
    }
    
    /* Add New Track In Pull */
    func addSong() {
        let song = selectedSpotifyTracks[selectedSpotifyTracks.count - 1]
        if let spotifyId = song.spotifyId, let songName = song.name {
            ApiManager.addSong(groupId: group.id, spotifyId: spotifyId, songName: songName) { (result) in
                switch result {
                case .success(let msg):
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowErrorAlertSong"), object: nil, userInfo: ["msg": msg!])
                default: break
                }
            }
        }
    }
    
    /* Remove Song From Pull */
    func removeSong(index: Int) {
        let song = visibleSpotifyTracks[index]
        if let spotifyId = song.spotifyId, let songName = song.name {
            ApiManager.removeSong(groupId: group.id, spotifyId: spotifyId, songName: songName)
        }
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
        guard let user: User = UserProfileCache.get(key: "user") else {return}
        if spotifyService.isSignedIn {
            print("Logged in spotify")
            print(SpotifyService.shared.shouldRefreshToken)
            let semaphore = DispatchSemaphore(value: 0)
            
            spotifyUser = UserProfileCache.get(key: "spotifyUser")
            
            let count = TracksCoreDataManager.shared.fetchTracks()
            
            if count.count == 0 || SpotifyService.shared.shouldRefreshToken || refresh {
                TracksCoreDataManager.shared.deleteTracks()
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
                spotifyTracks = TracksCoreDataManager.shared.fetchTracks()
                visibleSpotifyTracks = spotifyTracks
                cells = visibleSpotifyTracks.map {
                    let trackCellViewModel = MusicCellViewModel(track: $0)
                    return .track(viewModel: trackCellViewModel)
                }
            }
            
            // Getting And Checking Songs In Pull
            ApiManager.getSongs(groupId: group.id, userLogin: user.login) { (tracks) in
                for (_, song) in tracks.enumerated() {
                    self.selectedSpotifyTracks.append(contentsOf: self.visibleSpotifyTracks.filter(){$0.spotifyId == song.spotifyTrackId})
                }
                DispatchQueue.main.async {
                    completionHandler(.success(nil))
                }
            }
            
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
