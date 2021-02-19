//
//  MusicCoordinator.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

final class MusicCoordinator: Coordinator {
    
    private(set)var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController: MusicViewController = .instantiate()
        viewController.setTabBarItem(image: "music", selectedColor: .white, unSelectedColor: .gray, title: "Music", tabBarItemTitle: "Music")
        let musicViewModel = MusicViewModel()
        musicViewModel.coordinator = self
        viewController.viewModel = musicViewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /* Go to selected track screen */
    func goToTrack() {
        let trackCoordinator = TrackCoordinator(navigationController: navigationController)
        trackCoordinator.parentCoordinator = self
        childCoordinators.append(trackCoordinator)
        trackCoordinator.start()
    }
    
    func finishChild(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { (curCoordinator) -> Bool in
            return curCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
