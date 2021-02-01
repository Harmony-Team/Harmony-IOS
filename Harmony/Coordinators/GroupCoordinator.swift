//
//  GroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

final class GroupCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: GroupViewController = .instantiate()
        viewController.setTabBarItem(image: "group", selectedColor: .white, unSelectedColor: .gray, title: "Group", tabBarItemTitle: "Group")
        let groupsViewModel = GroupViewModel()
        groupsViewModel.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
}
