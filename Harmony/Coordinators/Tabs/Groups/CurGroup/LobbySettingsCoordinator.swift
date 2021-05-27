//
//  LobbySettingsCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 12.05.2021.
//

import UIKit

final class LobbySettingsCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator!
    var navigationController: UINavigationController
    var group: UserGroup
    
    init(navigationController: UINavigationController, group: UserGroup) {
        self.navigationController = navigationController
        self.group = group
    }
    
    func start() {
        let viewController: LobbySettingsViewController = .instantiate()
        viewController.hidesBottomBarWhenPushed = true
        viewController.title = group.name.uppercased()
        let lobbySettingsViewModel = LobbySettingsViewModel()
        lobbySettingsViewModel.group = group
        lobbySettingsViewModel.coordinator = self
        viewController.viewModel = lobbySettingsViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}

