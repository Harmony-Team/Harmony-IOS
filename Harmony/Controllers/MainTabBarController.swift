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
    
    var mainLayer: CALayer?
    var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.bgColor.cgColor
        shapeLayer.lineWidth = 0.5
        return shapeLayer
    }()
    
//    override var selectedViewController: UIViewController? {
//        didSet {
//            tabChangedTo(selectedIndex: selectedIndex)
//        }
//    }
////     Override selectedIndex for Programmatic changes
//    override var selectedIndex: Int {
//        didSet {
//            tabChangedTo(selectedIndex: selectedIndex)
//        }
//    }

    // handle new selection
     func tabChangedTo(selectedIndex: Int) {
//        if selectedIndex > 0 { tabBar.addShape(shapeLayer: &shapeLayer, layer: &mainLayer) }
//        else { tabBar.removeShape(shapeLayer: &shapeLayer, layer: &mainLayer) }
     }
    
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
//                UIViewController(),
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
        
//        setupMiddleButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 46
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = .mainColor
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        let menuButtonImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        menuButton.setImage(menuButtonImage, for: .normal)
        menuButton.tintColor = .white
        menuButton.addTarget(self, action: #selector(d), for: .touchUpInside)
        
        view.layoutIfNeeded()
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
