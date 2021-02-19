//
//  UIViewController+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit

fileprivate var aView: UIView?

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
    
    /* Show activity Indicator */
    func showActivityIndicator(alpha: CGFloat = 0) {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .mainColor
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
    
    /* Hide activity Indicator */
    func hideActivityIndicator() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    /* Show alert in registration/login form */
    func callAlert(with msg: String) {
        let alert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
