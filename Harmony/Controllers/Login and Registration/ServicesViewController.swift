//
//  ServicesViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit

class ServicesViewController: UIViewController {

    var viewModel: ServicesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    /* Spotify Authorisation */
    @IBAction func spotifySignUp(_ sender: UIButton) {
    }
    
    /* VK Authorisation */
    @IBAction func vkSignUp(_ sender: UIButton) {
        viewModel.authVK()
    }
    
    /* OK Authorisation */
    @IBAction func okSignUp(_ sender: UIButton) {
    }
}
