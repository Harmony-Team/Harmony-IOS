//
//  CreatedPlaylistCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 29.03.2021.
//

import UIKit

final class CreatedPlaylistCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: NewPlaylistCoordinator!
    var navigationController: UINavigationController
    var playlistName: String
    var playlistImage: UIImage
    
    init(navigationController: UINavigationController, playlistName: String, playlistImage: UIImage) {
        self.navigationController = navigationController
        self.playlistName = playlistName
        self.playlistImage = playlistImage
    }
    
    func start() {
        let viewController: NewGroupViewController = .instantiate(id: "PlaylistCreatedViewController")
        let createdPlaylistViewModel = PlaylistCreatedViewModel(coreDataManager: CoreDataManager(), spotifyPlaylistName: playlistName, spotifyPlaylistImage: playlistImage)
        createdPlaylistViewModel.coordinator = self
        viewController.playlistCreatedViewModel = createdPlaylistViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func closeWithoutSaving(_ goToRoom: Bool?) {
        navigationController.popViewController(animated: true)
        parentCoordinator.finishChild(coordinator: self)
    }
    
    deinit {
        print("DEINIT: NewGroupCoordinator")
    }
    
}
