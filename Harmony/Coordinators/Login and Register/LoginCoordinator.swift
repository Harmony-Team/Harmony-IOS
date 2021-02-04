//
//  LoginCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 02.02.2021.
//

import UIKit
import Foundation

final class LoginCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var window: UIWindow
    var navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController: LoginViewController = .instantiate()
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self
        viewController.viewModel = loginViewModel

        navigationController.navigationBar.tintColor = .gray
        navigationController.setViewControllers([viewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func goToRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        childCoordinators.append(registerCoordinator)
        registerCoordinator.start()
    }

    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}

