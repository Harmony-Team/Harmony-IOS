//
//  ProfileViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 31.01.2021.
//

import UIKit
import SwiftyVK
import Foundation

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(alpha: 1)
        
        /* Get user info */
        DispatchQueue.main.async {
            self.viewModel.getUserInfo {
                self.hideActivityIndicator()
                self.setupViews()
            }
        }
        
        let settingsImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(goToSettings))
        
        
    }
    
    private func setupViews() {
        userName.text = viewModel.user.login
        userImage.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        userImage.tintColor = .gray
    }
    
    /* Open user settings screen */
    @objc private func goToSettings() {
        viewModel.goToSettings()
    }
    
}
