//
//  MainTabBarController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
    let friendCoordinator = FriendsCoordinator(navigationController: UINavigationController())
    let groupCoordinator = GroupsListCoordinator(navigationController: UINavigationController())
//    let musicCoordinator = MusicCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.barTintColor = .clear
        
        profileCoordinator.start()
        friendCoordinator.start()
        groupCoordinator.start()
//        musicCoordinator.start()

        viewControllers =
            [
                profileCoordinator.navigationController,
                friendCoordinator.navigationController,
                groupCoordinator.navigationController,
//                musicCoordinator.navigationController
            ]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    @objc func d() {
        switch selectedIndex {
        case 1:
            print("Friends")
            friendCoordinator.addNewFriend()
            break
        case 3:
            print("Groups")
            groupCoordinator.addNewGroup()
            break
        case 4:
            print("Music")
            break
        default:
            break
        }
    }
    
}
