//
//  UIViewController+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

extension UIViewController {
    static func instantiate<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
        return viewController
    }
    
    /* Hide navigation tab */
    func hideNavController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /* Set tab bar items */
    func setTabBarItem(selectedImageSystemImageName: String, unselectedImageSystemImageName: String, selectedColor: UIColor, unSelectedColor: UIColor, tag: Int? = nil, title: String? = nil, tabBarItemTitle: String? = nil) {
        
        self.title = title
        
        tabBarItem = UITabBarItem(
            title: tabBarItemTitle,
            image: UIImage(systemName: unselectedImageSystemImageName)?
                .withTintColor(unSelectedColor, renderingMode: .alwaysTemplate),
            selectedImage: UIImage(systemName: selectedImageSystemImageName)?
                .withTintColor(selectedColor, renderingMode: .alwaysTemplate)
        )
        if let tag = tag {
            tabBarItem.tag = tag
        }
    }
    
    func setTabBarItem(image: String, selectedColor: UIColor, unSelectedColor: UIColor, tag: Int? = nil, title: String? = nil, tabBarItemTitle: String? = nil) {
        
        self.title = title
        
        tabBarItem = UITabBarItem(
            title: tabBarItemTitle,
            image: UIImage(named: image)?
                .withTintColor(selectedColor, renderingMode: .alwaysTemplate).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: image)?
                .withTintColor(selectedColor, renderingMode: .alwaysTemplate).withRenderingMode(.alwaysOriginal)
        )
        if let tag = tag {
            tabBarItem.tag = tag
        }
    }
    
    /* Dismiss view controller modal from left to right */
    func dismissFromLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}


extension UINavigationController {
    func pushFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
}

extension Notification.Name {
    struct Spotify {
        static let authURLOpened = Notification.Name("authURLOpened")
    }
}
