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
    
    /* Adding bg for view controller */
    func addBg(image: UIImage?, colorTop: UIColor, colorBottom: UIColor, alpha: CGFloat) {
        
        if let image = image {
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = image
            backgroundImage.clipsToBounds = true
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.alpha = alpha
            self.view.insertSubview(backgroundImage, at: 0)
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.view.bounds
                
        self.view.layer.masksToBounds = true
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func customizeNavBarController(bgColor: UIColor, textColor: UIColor) {
        
        let backArrowImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorImage = backArrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowImage
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: textColor,
            .font: UIFont.setFont(size: .Medium),
            .kern: 1.74
        ]
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
        
        var activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView()
        }
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
