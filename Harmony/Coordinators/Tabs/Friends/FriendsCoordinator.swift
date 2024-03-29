//
//  FriendsCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

final class FriendsCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: FriendsViewController = .instantiate()
//        viewController.setTabBarItem(image: "friends", selectedColor: .white, unSelectedColor: .gray, title: "FRIENDS", tabBarItemTitle: "Friends")
        viewController.title = "FRIENDS"
        let friendsViewModel = FriendsViewModel()
        friendsViewModel.coordinator = self
        viewController.viewModel = friendsViewModel
        navigationController.pushViewController(viewController, animated: false)
//        let viewController: ChatViewController = .instantiate()
//        viewController.setTabBarItem(image: "friends", selectedColor: .white, unSelectedColor: .gray, title: "CHATS", tabBarItemTitle: "Friends")
//        let friendsViewModel = ChatViewModel()
//        friendsViewModel.coordinator = self
//        viewController.viewModel = friendsViewModel
//        navigationController.pushViewController(viewController, animated: false)
    }
    
    /* Go to new friend window */
    func addNewFriend() {
        let newFriendCoordinator = NewFriendCoordinator(navigationController: navigationController)
        newFriendCoordinator.parentCoordinator = self
        childCoordinators.append(newFriendCoordinator)
        newFriendCoordinator.start()
    }
    
    /* Go To Friend Profile */
    func goToFriendProfile() {
        let friendProfileCoordinator = FriendProfileCoordinator(navigationController: navigationController)
        friendProfileCoordinator.parentCoordinator = self
        childCoordinators.append(friendProfileCoordinator)
        friendProfileCoordinator.start()
    }
    
    /* Go To Selected Section Coordinator */
    func goToSection(section: MenuSection) {
        goToSection(section: section, navigationController: navigationController, parentCoordinator: self)
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
