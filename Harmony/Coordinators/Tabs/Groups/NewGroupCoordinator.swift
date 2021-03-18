//
//  NewGroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

final class NewGroupCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupsListCoordinator!
    var navigationController: UINavigationController
    var navModal: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navModal = UINavigationController()
        let viewController: NewGroupViewController = .instantiate()
        let newGroupViewModel = NewGroupViewModel()
        newGroupViewModel.coordinator = self
        viewController.viewModel = newGroupViewModel
//        navModal.modalPresentationStyle = .fullScreen
        navModal?.setViewControllers([viewController], animated: true)
        navigationController.present(navModal!, animated: true, completion: nil)
    }
    
    func goToShareLink() {
        let shareCoordinator = ShareLinkCoordinator(navigationController: navModal!)
        shareCoordinator.parentCoordinator = self
        childCoordinators.append(shareCoordinator)
        shareCoordinator.start()
    }
    
    /* Go To Created Group */
    func goToGroup() {
        parentCoordinator.finishChild(coordinator: self, goToRoom: true)
    }
    
    func closeWithoutSaving(_ goToRoom: Bool?) {
        navModal?.dismiss(animated: true, completion: {
            self.parentCoordinator.finishChild(coordinator: self, goToRoom: goToRoom)
        })
        
    }
    
//    func finishChild(coordinator: Coordinator) {
//        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
//            return curCoordinator === coordinator
//        }) {
//            childCoordinators.remove(at: index)
//            closeWithoutSaving(true)
//        }
//    }
    
    deinit {
        print("DEINIT: NewGroupCoordinator")
    }
    
}
