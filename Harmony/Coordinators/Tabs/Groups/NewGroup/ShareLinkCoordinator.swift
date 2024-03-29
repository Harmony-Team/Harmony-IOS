//
//  ShareLinkCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 09.03.2021.
//

import UIKit

final class ShareLinkCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: NewGroupCoordinator!
    var navigationController: UINavigationController
    var inviteCode: String!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: ShareLinkViewController = .instantiate()
        let shareViewModel = ShareLinkViewModel()
        shareViewModel.coordinator = self
        shareViewModel.inviteCode = inviteCode
        viewController.viewModel = shareViewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /* Go To Group: Close current window and go to coordinator from GroupsListCoordinator */
    func goToGroup() {
//        let groupCoordinator = GroupCoordinator(navigationController: navigationController)
//        groupCoordinator.parentCoordinator = self
//        childCoordinators.append(groupCoordinator)
//        groupCoordinator.start()
//        navigationController.popViewController(animated: true)
        closeWithoutSaving()
    }
    
    func closeWithoutSaving() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    deinit {
        print("DEINIT: ShareLinkCoordinator")
    }
    
}
