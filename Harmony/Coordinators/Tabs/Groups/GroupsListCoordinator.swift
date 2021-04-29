//
//  GroupCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import CoreData

final class GroupsListCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var saveEvent = {}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: GroupsListViewController = .instantiate()
        viewController.setTabBarItem(image: "group", selectedColor: .white, unSelectedColor: .gray, title: "GROUPS", tabBarItemTitle: "Group")
        viewController.tabBarController?.tabBar.isHidden = true
        let groupsViewModel = GroupsListViewModel()
        saveEvent = groupsViewModel.reload
        groupsViewModel.coordinator = self
        viewController.viewModel = groupsViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /* Go to "Create new group" window */
    func addNewGroup() {
        let newGroupCoordinator = NewGroupCoordinator(navigationController: navigationController)
        newGroupCoordinator.parentCoordinator = self
        childCoordinators.append(newGroupCoordinator)
        newGroupCoordinator.start()
    }
    
    /* Go To Selected Section Coordinator */
    func goToSection(section: MenuSection) {
        goToSection(section: section, navigationController: navigationController, parentCoordinator: self)
    }
    
    /* Go To Created Group */
    func goToCreatedGroup(id: Int, group: UserGroup) {
        let groupCoordinator = GroupCoordinator(navigationController: navigationController, group: group)
        groupCoordinator.parentCoordinator = self
        childCoordinators.append(groupCoordinator)
        groupCoordinator.start()
    }
//    func goToCreatedGroup(id: NSManagedObjectID) {
//        let groupCoordinator = GroupCoordinator(navigationController: navigationController)
//        groupCoordinator.parentCoordinator = self
//        childCoordinators.append(groupCoordinator)
//        groupCoordinator.start()
//    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
//    func finishChild(coordinator: Coordinator, goToRoom: Bool?) {
//        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
//            return curCoordinator === coordinator
//        }) {
//            childCoordinators.remove(at: index)
////            if let _ = goToRoom, let id = id { // Go To group room
////                goToCreatedGroup(id: id)
////            }
//        }
//    }
    
}
