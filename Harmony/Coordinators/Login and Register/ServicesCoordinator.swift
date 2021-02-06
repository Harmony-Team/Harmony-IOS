//
//  ServicesCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import Foundation

final class ServicesCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: RegisterCoordinator!
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: ServicesViewController = .instantiate()
        let servicesViewModel = ServicesViewModel()
        servicesViewModel.coordinator = self
        viewController.viewModel = servicesViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToProfile() {
        let profileCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    func goBack() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
}


