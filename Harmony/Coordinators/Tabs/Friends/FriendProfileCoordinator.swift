//
//  FriendProfileCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 08.05.2021.
//

import UIKit

final class FriendProfileCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: FriendsCoordinator!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FriendProfileViewController = .instantiate()
        let friendProfileViewModel = FriendProfileViewModel()
        friendProfileViewModel.coordinator = self
        viewController.viewModel = friendProfileViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
