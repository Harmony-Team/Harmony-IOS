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
    
}
