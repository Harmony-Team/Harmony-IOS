//
//  TrackCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 18.02.2021.
//

import UIKit

final class TrackCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var parentCoordinator: MusicCoordinator!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let navModal = UINavigationController()
        let viewController: TrackViewController = .instantiate()
        let trackViewModel = TrackViewModel()
        trackViewModel.coordinator = self
        viewController.viewModel = trackViewModel
        navModal.setViewControllers([viewController], animated: false)
        navigationController.present(navModal, animated: true, completion: nil)
    }
    
    func goBack() {
        parentCoordinator.finishChild(coordinator: self)
    }
}
