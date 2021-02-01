//
//  MusicCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

final class MusicCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MusicViewController = .instantiate()
        viewController.setTabBarItem(image: "music", selectedColor: .white, unSelectedColor: .gray, title: "Music", tabBarItemTitle: "Music")
        let musicViewModel = MusicViewModel()
        musicViewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
