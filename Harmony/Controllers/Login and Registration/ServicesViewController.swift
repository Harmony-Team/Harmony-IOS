//
//  ServicesViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import SafariServices
import VK_ios_sdk
import SwiftyVK
import ok_ios_sdk
import WebKit
import Alamofire

class ServicesViewController: UIViewController {
    
    var viewModel: ServicesViewModel!
    
    /* OK */
    var okScope = ["VALUABLE_ACCESS", "LONG_ACCESS_TOKEN", "PHOTO_CONTENT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /* Spotify Authorization */
    @IBAction func spotifySignUp(_ sender: UIButton) {
        spotifyAuthVC()
    }
    
    var webView: UIWebView!
    func spotifyAuthVC() {
        // Create Spotify Auth ViewController
        let spotifyVC = UIViewController()
        // Create WebView
        webView = UIWebView()
        webView?.delegate = self
        spotifyVC.view.addSubview(webView)
        webView.frame = spotifyVC.view.bounds
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let url = viewModel.spotifyService.signInUrl else { return }
        let urlRequest = URLRequest.init(url: url)
        webView.loadRequest(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: spotifyVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        spotifyVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        spotifyVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        spotifyVC.navigationItem.title = "spotify.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = .white
        navController.navigationBar.barTintColor = .white
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    /* VK Authorization */
    @IBAction func vkSignUp(_ sender: UIButton) {
        viewModel.authVK()
    }
    
    /* OK Authorization */
    @IBAction func okSignUp(_ sender: UIButton) {
        OKSDK.authorize(withPermissions: okScope) { data in
            print(data)
        } error: { error in
            print(error)
        }
        
    }
    
    /* End registration. Go to profile */
    @IBAction func endRegistration(_ sender: UIButton) {
        viewModel.setIntergrationIDs()
//        viewModel.endRegistration()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}

extension ServicesViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        viewModel.requestForCallbackURL(request: request) {
            self.dismiss(animated: true, completion: nil)
        }
        return true
    }
}
