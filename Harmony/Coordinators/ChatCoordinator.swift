//
//  ChatCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 06.02.2021.
//

import UIKit

final class ChatCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var parentCoordinator: GroupsListCoordinator!
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let navModal = UINavigationController()
//        let viewController: ChatViewController = .instantiate()
//        let chatViewModel = ChatViewModel()
//        chatViewModel.coordinator = self
//        viewController.viewModel = chatViewModel
//        navModal.modalPresentationStyle = .fullScreen
//        navModal.setViewControllers([viewController], animated: true)
//        navigationController.pushFromLeft(controller: navModal)
    }
    
    func closeWithoutSaving() {
        parentCoordinator.finishChild(coordinator: self, goToRoom: nil)
    }
    
}
