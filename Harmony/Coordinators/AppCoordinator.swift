//
//  AppCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func start()
    func finishChild(coordinator: Coordinator)
}

final class AppCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let mainCoordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(mainCoordinator)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        mainCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}

/* Extension To Move To Sections */
extension Coordinator {
    func profile(navigationController: UINavigationController) {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.isChoosen = true
        profileCoordinator.start()
    }
    
    func groups(navigationController: UINavigationController) {
        let groupsCoordinator = GroupsListCoordinator(navigationController: navigationController)
        groupsCoordinator.start()
    }
    
    func friends(navigationController: UINavigationController) {
        let friendsCoordinator = FriendsCoordinator(navigationController: navigationController)
        friendsCoordinator.start()
    }
    
    func settings(navigationController: UINavigationController, parentCoordinator: Coordinator) {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
        settingsCoordinator.parentCoordinator = parentCoordinator
        settingsCoordinator.start()
    }
    
    /* Go To Selected Section Coordinator */
    func goToSection(section: MenuSection, navigationController: UINavigationController, parentCoordinator: Coordinator) {
        switch section {
        case .Profile:
            profile(navigationController: navigationController)
        case .Groups:
            groups(navigationController: navigationController)
        case .Friends:
            friends(navigationController: navigationController)
        case .Settings:
            settings(navigationController: navigationController, parentCoordinator: parentCoordinator)
        }
    }
    
}
