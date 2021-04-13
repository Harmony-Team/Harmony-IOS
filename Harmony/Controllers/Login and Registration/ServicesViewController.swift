//
//  ServicesViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import WebKit

class ServicesViewController: UIViewController {
    
    var viewModel: ServicesViewModel!
    
    @IBOutlet weak var integrateWithLabel: UILabel!
    
    /* Spotify */
    var spotifyWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBg(image: UIImage(named: "bg2"), colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 0.22)
        
        integrateWithLabel.font = UIFont.setFont(size: .Small)
        integrateWithLabel.addKern(1.74)
    }
    
    /* Spotify Authorization */
    @IBAction func spotifySignUp(_ sender: UIButton) {
        spotifyWebView = WKWebView()
        self.spotifyAuthVC(spotifyWebView: spotifyWebView)
    }

    /* End registration. Go to profile */
    @IBAction func endRegistration(_ sender: UIButton) {
        viewModel.setIntergrationIDs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}

extension ServicesViewController {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        viewModel.requestForCallbackURL(request: navigationAction.request) {
            self.dismiss(animated: true, completion: nil)
        }
        
        decisionHandler(.allow)
    }
}
