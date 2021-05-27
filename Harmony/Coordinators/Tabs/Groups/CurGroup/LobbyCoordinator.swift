//
//  GroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

final class LobbyCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator!
    var navigationController: UINavigationController
    var group: UserGroup
    var selectedSpotifyTracks = [SpotifyTrack]()
    var updateSelectedTracks = {}
    
    init(navigationController: UINavigationController, group: UserGroup) {
        self.navigationController = navigationController
        self.group = group
    }
    
    func start() {
        if let user: User = UserProfileCache.get(key: "user") {
            let id = group.hostLogin == user.login ? "CreatedGroupViewController" : "GroupViewController"
            let viewController: LobbyViewController = .instantiate(id: id)
            viewController.hidesBottomBarWhenPushed = true
            viewController.title = group.name.uppercased()
            let groupViewModel = GroupViewModel()
            groupViewModel.group = group
            groupViewModel.selectedSpotifyTracks = selectedSpotifyTracks
            groupViewModel.coordinator = self
            updateSelectedTracks = groupViewModel.reload
            viewController.viewModel = groupViewModel
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func createNewPlaylist(tracks: Int, totalPartitions: Int, readyPartitions: Int) {
        let newPlaylistCoordinator = NewPlaylistCoordinator(navigationController: navigationController)
        newPlaylistCoordinator.parentCoordinator = self
        newPlaylistCoordinator.tracksCount = tracks
        newPlaylistCoordinator.partitionsTotalCount = totalPartitions
        newPlaylistCoordinator.partitionsReadyCount = readyPartitions
        childCoordinators.append(newPlaylistCoordinator)
        newPlaylistCoordinator.start()
    }
    
    /* Open Music Search Screen */
    func goToMusicSearching(spotifyTracks: [SpotifyTrack], selectedSpotifyTracks: [SpotifyTrack]) {
        let musicSearchCoordinator = MusicSearchCoordinator(navigationController: navigationController, spotifyTracks: spotifyTracks, selectedSpotifyTracks: selectedSpotifyTracks)
        musicSearchCoordinator.parentCoordinator = self
        musicSearchCoordinator.group = group
        childCoordinators.append(musicSearchCoordinator)
        musicSearchCoordinator.start()
    }
    
    /* Open Friends Adding Screen */
    func goToFriendsSearching() {
        let friendsSearchCoordinator = FriendsSearchCoordinator(navigationController: navigationController)
        friendsSearchCoordinator.parentCoordinator = self
        childCoordinators.append(friendsSearchCoordinator)
        friendsSearchCoordinator.start()
    }
    
    /* Open Lobby Settings Screen */
    func goToLobbySettings() {
        let lobbySettingsCoordinator = LobbySettingsCoordinator(navigationController: navigationController, group: group)
        lobbySettingsCoordinator.parentCoordinator = self
        childCoordinators.append(lobbySettingsCoordinator)
        lobbySettingsCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func finishChild(coordinator: Coordinator, goToRoom: Bool?, selectedSpotifyTracks: [SpotifyTrack]? = nil) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
            if let selectedTracks = selectedSpotifyTracks { // Update Selected Tracks
                self.selectedSpotifyTracks = selectedTracks
                updateSelectedTracks()
            }
        }
    }
    
}

