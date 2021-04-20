//
//  ProfileCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import Foundation

final class ProfileCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var isChoosen = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ProfileViewController = .instantiate()
        viewController.setTabBarItem(image: "profile", selectedColor: .white, unSelectedColor: .gray, title: "PROFILE", tabBarItemTitle: "Profile")
        let profileViewModel = ProfileViewModel()
        profileViewModel.coordinator = self
        profileViewModel.isChosen = isChoosen
        viewController.viewModel = profileViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /* Go To Selected Section Coordinator */
    func goToSection(section: MenuSection) {
        goToSection(section: section, navigationController: navigationController)
    }
    
    /* Settings screen */
    func goToSettings(for user: User) {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.parentCoordinator = self
//        settingsCoordinator.user = user
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
