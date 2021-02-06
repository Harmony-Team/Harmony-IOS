//
//  MainTabBarCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit
import Foundation

final class MainTabBarCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MainTabBarController = .instantiate()
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
}
