//
//  ForgotPasswordCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 22.02.2021.
//

import UIKit

final class ForgotPasswordCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: LoginCoordinator!
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: ForgotPasswordViewController = .instantiate(storyboardName: "LoginAndRegister")
        let forgotPasswordViewModel = ForgotPasswordViewModel()
        forgotPasswordViewModel.coordinator = self
        viewController.viewModel = forgotPasswordViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }

    func goBack() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
}

