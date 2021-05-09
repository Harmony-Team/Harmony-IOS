//
//  FriendsSearchCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 06.05.2021.
//

import UIKit

final class FriendsSearchCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupCoordinator!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FriendsSearchViewController = .instantiate()
        let friendsSearchViewModel = FriendsSearchViewModel()
        friendsSearchViewModel.coordinator = self
        viewController.viewModel = friendsSearchViewModel
        navigationController.fadeTo(viewController)
    }
    
    func goToLobby() {
        navigationController.popViewController(animated: false)
        parentCoordinator.finishChild(coordinator: self, goToRoom: nil)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
