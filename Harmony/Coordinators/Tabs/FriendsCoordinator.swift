//
//  FriendsCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

final class FriendsCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FriendsViewController = .instantiate()
        viewController.setTabBarItem(image: "friends", selectedColor: .white, unSelectedColor: .gray, title: "Friends", tabBarItemTitle: "Friends")
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.coordinator = self
        viewController.viewModel = friendsViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
