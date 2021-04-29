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
    var parentCoordinator: Coordinator!
//    var user: User!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: SettingsViewController = .instantiate()
        let settingsViewModel = SettingsViewModel()
        settingsViewModel.coordinator = self
//        settingsViewModel.user = user
        viewController.viewModel = settingsViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func goToEditScreen() {
        let editProfileCoordinator = EditProfileCoordinator(navigationController: navigationController)
        editProfileCoordinator.parentCoordinator = self
        childCoordinators.append(editProfileCoordinator)
        editProfileCoordinator.start()
    }
    
    /* Go To Selected Section Coordinator */
    func goToSection(section: MenuSection) {
        goToSection(section: section, navigationController: navigationController, parentCoordinator: self)
    }

    /* Logout and go to login form */
    func goToLogin() {
        parentCoordinator.finishChild(coordinator: self)
        
        // Go to login screen
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let appDel: SceneDelegate = (scene?.delegate as? SceneDelegate) {
                appDel.loginCoordinator = LoginCoordinator(window: appDel.window!)
                appDel.loginCoordinator?.start()
            }
        } else {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
        }
        
    }
    
    /* Go back to profile */
    func goToProfile() {
//        parentCoordinator.finishChild(coordinator: self)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
