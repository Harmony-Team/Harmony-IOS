//
//  SettingsCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: ProfileCoordinator!
    var user: User!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SettingsViewController = .instantiate()
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.coordinator = self
        settingsViewModel.user = user
        viewController.viewModel = settingsViewModel
        navigationController.pushViewController(viewController, animated: false)
    }

    /* Logout and go to login form */
    func goToLogin() {
        parentCoordinator.finishChild(coordinator: self)
        
        // Go to login screen
        let scene = UIApplication.shared.connectedScenes.first
        if let appDel: SceneDelegate = (scene?.delegate as? SceneDelegate) {
            appDel.loginCoordinator = LoginCoordinator(window: appDel.window!)
            appDel.loginCoordinator?.start()
        }
        
    }
    
}
