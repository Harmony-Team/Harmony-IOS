//
//  NewGroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

final class NewGroupCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupCoordinator!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let navModal = UINavigationController()
        let viewController: NewGroupViewController = .instantiate()
        let newGroupViewModel = NewGroupViewModel()
        newGroupViewModel.coordinator = self
        viewController.viewModel = newGroupViewModel
        navModal.modalPresentationStyle = .fullScreen
        navModal.setViewControllers([viewController], animated: true)
        navigationController.present(navModal, animated: true, completion: nil)
    }
    
    func closeWithoutSaving() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
}
