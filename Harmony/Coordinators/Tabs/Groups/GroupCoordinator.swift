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
        let viewController: GroupsViewController = .instantiate()
        viewController.setTabBarItem(image: "group", selectedColor: .white, unSelectedColor: .gray, title: "Group", tabBarItemTitle: "Group")
        let groupsViewModel = GroupViewModel()
        groupsViewModel.coordinator = self
        viewController.viewModel = groupsViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /* Go to new group window */
    func addNewGroup() {
        let newGroupCoordinator = NewGroupCoordinator(navigationController: navigationController)
        newGroupCoordinator.parentCoordinator = self
        childCoordinators.append(newGroupCoordinator)
        newGroupCoordinator.start()
    }
    
    /* Go to current chat group */
    func goToGroupChat() {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController)
        chatCoordinator.parentCoordinator = self
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
