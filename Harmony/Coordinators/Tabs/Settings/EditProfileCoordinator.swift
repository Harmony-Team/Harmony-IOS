//
//  EditProfileCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 26.03.2021.
//

import UIKit

final class EditProfileCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: SettingsCoordinator!
    var user: User!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: EditProfileViewController = .instantiate()
        var editProfileViewModel = EditProfileViewModel()
        editProfileViewModel.coordinator = self
        viewController.viewModel = editProfileViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /* Go back to settings */
    func goToSettings() {
//        parentCoordinator.finishChild(coordinator: self)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    deinit {
        print("Deinit Edit")
    }
    
}
