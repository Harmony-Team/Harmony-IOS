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
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController: RegistrationViewController = .instantiate()
//        let loginViewModel = LoginViewModel()
//        loginViewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

