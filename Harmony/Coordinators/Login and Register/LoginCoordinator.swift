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
        let viewController: LoginViewController = .instantiate(storyboardName: "LoginAndRegister")
        let loginViewModel = LoginViewModel()
        loginViewModel.coordinator = self
        viewController.viewModel = loginViewModel

        navigationController.navigationBar.tintColor = .gray
        navigationController.setViewControllers([viewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    /* Go To Profile Screen */
    func goToProfile() {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    /* Go To Registration Screen */
    func goToRegister() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.append(registerCoordinator)
        registerCoordinator.start()
    }
    
    /* Go To Forgot Password Screen */
    func goToForgotPassword() {
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(navigationController: navigationController)
        forgotPasswordCoordinator.parentCoordinator = self
        childCoordinators.append(forgotPasswordCoordinator)
        forgotPasswordCoordinator.start()
    }
    
    /* Go To Spotify Integration After Registration */
    func goToServices(with data: Any) {
        let servicesCoordinator = ServicesCoordinator(navigationController: navigationController, data: data)
        servicesCoordinator.parentCoordinator = self
        childCoordinators.append(servicesCoordinator)
        servicesCoordinator.start()
    }

    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}

