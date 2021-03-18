//
//  GroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

final class GroupCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupsListCoordinator!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: GroupViewController = .instantiate()
        viewController.hidesBottomBarWhenPushed = true
        let groupViewModel = GroupViewModel()
        groupViewModel.coordinator = self
        viewController.viewModel = groupViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

