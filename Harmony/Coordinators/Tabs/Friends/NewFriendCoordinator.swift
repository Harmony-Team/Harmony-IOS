//
//  NewFriendCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

final class NewFriendCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: FriendsCoordinator!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let navModal = UINavigationController()
        let viewController: NewFriendViewController = .instantiate()
        let newFriendViewModel = NewFriendViewModel()
        newFriendViewModel.coordinator = self
        viewController.viewModel = newFriendViewModel
        navModal.modalPresentationStyle = .fullScreen
        navModal.setViewControllers([viewController], animated: true)
        navigationController.present(navModal, animated: true, completion: nil)
    }
    
    func closeWithoutSaving() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
}
