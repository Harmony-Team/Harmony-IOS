//
//  MusicSearchCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 01.04.2021.
//

import UIKit

final class MusicSearchCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupCoordinator!
    var navigationController: UINavigationController
    var spotifyTracks: [SpotifyTrack]
    var group: UserGroup!
    var selectedSpotifyTracks: [SpotifyTrack]
    
    init(navigationController: UINavigationController, spotifyTracks: [SpotifyTrack], selectedSpotifyTracks: [SpotifyTrack]) {
        self.navigationController = navigationController
        self.spotifyTracks = spotifyTracks
        self.selectedSpotifyTracks = selectedSpotifyTracks
    }
    
    func start() {
        let viewController: MusicSearchViewController = .instantiate()
        let musicSearchViewModel = MusicSearchViewModel(spotifyTracks: spotifyTracks, selectedSpotifyTracks: selectedSpotifyTracks)
        musicSearchViewModel.coordinator = self
        musicSearchViewModel.group = group
        viewController.viewModel = musicSearchViewModel
        navigationController.fadeTo(viewController)
    }
    
    func goToLobby(selectedSpotifyTracks: [SpotifyTrack]) {
        navigationController.popViewController(animated: false)
        parentCoordinator.finishChild(coordinator: self, goToRoom: nil, selectedSpotifyTracks: selectedSpotifyTracks)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
