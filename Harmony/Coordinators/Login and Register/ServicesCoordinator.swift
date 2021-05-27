//
//  ServicesCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import Foundation

final class ServicesCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: LoginCoordinator!
    var navigationController: UINavigationController!
    var data: Any!
    
    init(navigationController: UINavigationController, data: Any) {
        self.navigationController = navigationController
        self.data = data
    }

    func start() {
        let viewController: ServicesViewController = .instantiate(storyboardName: "LoginAndRegister")
        let servicesViewModel = ServicesViewModel()
        servicesViewModel.coordinator = self
        servicesViewModel.user = data as? User
        viewController.viewModel = servicesViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToProfile() {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func goBack() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
}


