//
//  NewPlaylistCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 25.03.2021.
//

import UIKit

final class NewPlaylistCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupCoordinator!
    var navigationController: UINavigationController
    var navModal: UINavigationController?
    var tracksCount: Int!
    var partitionsTotalCount: Int!
    var partitionsReadyCount: Int!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navModal = UINavigationController()
        let viewController: NewGroupViewController = .instantiate(id: "NewPlaylistViewController")
        let newPlaylistViewModel = NewPlaylistViewModel(coreDataManager: GroupsCoreDataManager())
        newPlaylistViewModel.coordinator = self
        newPlaylistViewModel.tracksCount = tracksCount
        newPlaylistViewModel.partitionsTotalCount = partitionsTotalCount
        newPlaylistViewModel.partitionsReadyCount = partitionsReadyCount
        viewController.newPlaylistViewModel = newPlaylistViewModel
        navModal?.setViewControllers([viewController], animated: true)
        navigationController.present(navModal!, animated: true, completion: nil)
    }
    
    func goToCreatedPlaylist(name: String, image: UIImage) {
        let cretedPlaylistCoordinator = CreatedPlaylistCoordinator(navigationController: navModal!, playlistName: name, playlistImage: image)
        cretedPlaylistCoordinator.parentCoordinator = self
        childCoordinators.append(cretedPlaylistCoordinator)
        cretedPlaylistCoordinator.start()
    }
    
    func closeWithoutSaving(_ goToRoom: Bool?) {
        navModal?.dismiss(animated: true, completion: {
            self.parentCoordinator.finishChild(coordinator: self, goToRoom: goToRoom)
        })
        
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    deinit {
        print("DEINIT: NewGroupCoordinator")
    }
    
}
