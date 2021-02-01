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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ProfileViewController = .instantiate()
        viewController.setTabBarItem(image: "profile", selectedColor: .white, unSelectedColor: .gray, title: "Profile", tabBarItemTitle: "Profile")
        let profileViewModel = ProfileViewModel()
        profileViewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
