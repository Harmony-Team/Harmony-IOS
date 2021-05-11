//
//  JoinGroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 11.05.2021.
//

import UIKit

final class JoinGroupCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupsListCoordinator!
    var navigationController: UINavigationController
    var navModal: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navModal = UINavigationController()
        let viewController: JoinGroupViewController = .instantiate()
        let joinGroupViewModel = JoinGroupViewModel()
        joinGroupViewModel.coordinator = self
        viewController.viewModel = joinGroupViewModel
        navModal?.setViewControllers([viewController], animated: true)
        navigationController.present(navModal!, animated: true, completion: nil)
    }
    
    /* Go To Created Group */
    func goToGroup() {
        parentCoordinator.saveEvent()
        parentCoordinator.finishChild(coordinator: self)
    }
    
    /* Go To Joined Group */
    func goToJoinedGroup(group: UserGroup) {
        navModal?.dismiss(animated: true, completion: {
            self.parentCoordinator.saveEvent()
            self.parentCoordinator.finishChild(coordinator: self)
            let groupCoordinator = GroupCoordinator(navigationController: self.navigationController, group: group)
            groupCoordinator.parentCoordinator = self
            self.childCoordinators.append(groupCoordinator)
            groupCoordinator.start()
        })
    }
    
    func closeWithoutSaving() {
        parentCoordinator.finishChild(coordinator: self)
    }
    
    func closeWithoutSaving(_ goToRoom: Bool?) {
        navModal?.dismiss(animated: true, completion: {
            self.goToGroup()
            //            self.parentCoordinator.finishChild(coordinator: self, goToRoom: goToRoom)
        })
        
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
            closeWithoutSaving(true)
        }
    }
    
    deinit {
        print("DEINIT: JoinGroupCoordinator")
    }
    
}
