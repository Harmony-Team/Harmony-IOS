//
//  PlaylistCreatedViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 29.03.2021.
//

import UIKit

class PlaylistCreatedViewModel {
    
    var coordinator: CreatedPlaylistCoordinator!
    var coreDataManager: GroupsCoreDataManager?
    var spotifyPlaylistName: String
    var spotifyPlaylistImage: UIImage
    
    init(coreDataManager: GroupsCoreDataManager, spotifyPlaylistName: String, spotifyPlaylistImage: UIImage) {
        self.coreDataManager = coreDataManager
        self.spotifyPlaylistName = spotifyPlaylistName
        self.spotifyPlaylistImage = spotifyPlaylistImage
    }

    /* Create New Group */
    func openPlaylistInSpotify() {
        
    }

    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
    
}
