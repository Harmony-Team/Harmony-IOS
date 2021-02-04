//
//  RegisterCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import Foundation

final class RegisterCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: LoginCoordinator!
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: RegistrationViewController = .instantiate()
        let registerViewModel = RegisterViewModel()
        registerViewModel.coordinator = self
        viewController.viewModel = registerViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToServices() {
        let servicesCoordinator = ServicesCoordinator(navigationController: navigationController)
        servicesCoordinator.parentCoordinator = self
        childCoordinators.append(servicesCoordinator)
        servicesCoordinator.start()
    }
    
    func goBack() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}

