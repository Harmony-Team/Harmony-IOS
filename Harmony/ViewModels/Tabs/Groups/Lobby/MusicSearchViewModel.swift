//
//  MusicSearchViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 01.04.2021.
//

import UIKit

class MusicSearchViewModel {
    
    var coordinator: MusicSearchCoordinator!
    
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
    
}
