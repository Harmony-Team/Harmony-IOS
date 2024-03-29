//
//  NewPlaylistViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 25.03.2021.
//

import UIKit

class NewPlaylistViewModel {
    
    var coordinator: NewPlaylistCoordinator!
    var coreDataManager: GroupsCoreDataManager?
    
    // Playlist Details
    var tracksCount: Int!
    var participantsTotalCount: Int!
    var participantsReadyCount: Int!
    
    init(coreDataManager: GroupsCoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    /* Create New Group */
    func createNewPlaylist(with name: String, image: UIImage) {
        print("Create \(name)")
        //TODO:CREATE PLAYLIST
        
        goToCreatedPlayilstScreen(name: name, image: image)
    }
    
    func goToCreatedPlayilstScreen(name: String, image: UIImage) {
        coordinator.goToCreatedPlaylist(name: name, image: image)
    }

    func closeWindow() {
        coordinator.closeWithoutSaving(nil)
    }
    
}

