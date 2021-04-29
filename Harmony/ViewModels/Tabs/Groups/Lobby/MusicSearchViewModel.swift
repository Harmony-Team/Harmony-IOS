//
//  MusicSearchViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.04.2021.
//

import UIKit

class MusicSearchViewModel {
    
    var coordinator: MusicSearchCoordinator!
    
    /* Group Info */
    var group: UserGroup!
    
    private var ApiManager = APIManager.shared
    var spotifyTracks: [SpotifyTrack]
    var visibleSpotifyTracks = [SpotifyTrack]() // Tracks Visible In Table View
    var selectedSpotifyTracks: [SpotifyTrack] // Selected Tracks
    
    init(spotifyTracks: [SpotifyTrack], selectedSpotifyTracks: [SpotifyTrack]) {
        self.spotifyTracks = spotifyTracks
        self.selectedSpotifyTracks = selectedSpotifyTracks
        self.visibleSpotifyTracks = spotifyTracks
    }
    
    func goToLobbyViewController() {
        coordinator.goToLobby(selectedSpotifyTracks: selectedSpotifyTracks)
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
    
}
