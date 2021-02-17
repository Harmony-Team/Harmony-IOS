//
//  ProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import Foundation

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get user info */
        viewModel.getUserInfo()
        
        let settingsImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(goToSettings))
        
        setupViews()
    }
    
    
    
    private func setupViews() {
        userName.text = viewModel.user.username
        userImage.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        userImage.tintColor = .gray
    }
    
    /* Open user settings screen */
    @objc private func goToSettings() {
        viewModel.goToSettings()
    }
    
}
