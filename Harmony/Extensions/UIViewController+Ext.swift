//
//  UIViewController+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import WebKit

fileprivate var aView: UIView?

enum AlertError: Error {
    case Cancel
    case Success
}

extension UIViewController: WKNavigationDelegate {
    static func instantiate<T>(id: String? = nil) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        var viewController: T
        if let id = id {
            viewController = storyboard.instantiateViewController(withIdentifier: "\(id.self)") as! T
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
        }
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
    
    /* Show alert with two options */
    func callAlertWithOptions(title: String, msg: String, completion: @escaping (AlertError) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: { (_) in
            completion(.Cancel)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (_) in
            completion(.Success)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /* Show Bottom Alert */
    func callBottomAlert(msg: String, completion: @escaping (AlertError) -> Void) {
        let deleteAlert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Group", style: .destructive) { (action: UIAlertAction) in
            completion(.Success)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            completion(.Cancel)
        }
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    /* Show Spotify Login Screen */
    func spotifyAuthVC(spotifyWebView: WKWebView) {
        // Create Spotify Auth ViewController
        let spotifyVC = UIViewController()
        
        spotifyWebView.navigationDelegate = self
        spotifyVC.view.addSubview(spotifyWebView)
        spotifyWebView.frame = spotifyVC.view.bounds
        spotifyWebView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let url = SpotifyService.shared.signInUrl else { return }
        let urlRequest = URLRequest.init(url: url)
        spotifyWebView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: spotifyVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.setNavigationBarHidden(true, animated: false)
        
        self.present(navController, animated: true, completion: nil)
    }
}


/* Side Menu Extension */
extension UIViewController {
    /* Add Navigation Side Menu View */
    func addSideMenuView(menuView: SideMenuView) {
        view.addSubview(menuView)
    }
    
    /* Setting Up Content View */
    func setupContent(menuView: SideMenuView, contentView: UIView) {
        menuView.addSubview(contentView)
        contentView.layer.zPosition = 20
        contentView.setGradientFill(colorTop: UIColor.loginGradientColorTop.cgColor, colorBottom: UIColor.loginGradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
    }
    
    /* Open / Close menu */
    func goToMenu(contentView: UIView, menuShow: inout Bool, withAnimation: Bool, completion: (()->())? = nil) {
        menuShow.toggle()
        
        var t = CGAffineTransform.identity
        let scaleCoef: CGFloat = menuShow ? 0.8 : 1.0
        let cornerRadius: CGFloat = menuShow ? 20 : 0
        t = t.translatedBy(x: menuShow ? UIScreen.main.bounds.width / 2 : 0, y: menuShow ? 44 : 0)
        t = t.scaledBy(x: scaleCoef, y: scaleCoef)
        
        navigationController?.setNavigationBarHidden(menuShow, animated: true)
        tabBarController?.tabBar.isHidden = menuShow
        
        if menuShow {
            contentView.layer.cornerRadius = cornerRadius
            UIView.animate(withDuration: withAnimation ? 0.5 : 0, delay: 0, usingSpringWithDamping: withAnimation ? 0.5 : 0, initialSpringVelocity: 0, options: .curveEaseInOut) {
                contentView.transform = t
            }
        } else {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                contentView.transform = t
                completion?()
            } completion: { (_) in
                contentView.layer.cornerRadius = cornerRadius
                
            }
        }
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
    
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0
        transition.type = .fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}

