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
    
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    
    private var latestGroupsCollectionView = LatestGroupsCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivityIndicator(alpha: 1)
        
        /* Get user info */
        DispatchQueue.main.async {
            self.viewModel.getUserInfo {
                self.hideActivityIndicator()
                self.setupViews()
                self.setupCollectionView()
            }
        }
        
        addBg(image: nil, colorTop: .loginGradientColorTop, colorBottom: .loginGradientColorBottom, alpha: 1)
        customizeNavBarController(bgColor: .bgColor, textColor: .white)
        
        let settingsImage = UIImage(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingsImage, style: .done, target: self, action: #selector(goToSettings))
        
    }
    
    private func setupViews() {
        userName.text = viewModel.user.login
        userId.text = "@\(viewModel.user.login)".uppercased()
        
        userName.font = UIFont.setFont(size: .ExtraLarge)
        userId.font = UIFont.setFont(size: .Medium)
        
        [userName, userId].forEach {
            $0?.textColor = .white
            $0?.addKern(1.74)
        }
        
        userImageView.backgroundColor = .clear
        userImageView.setupShadow(cornerRad: userImage.frame.width / 2, shadowRad: 5, shadowOp: 0.4, offset: CGSize(width: 8, height: 8))
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.backgroundColor = .mainTextColor
        userImage.image = UIImage(named: "groupImage1")
        userImage.contentMode = .scaleAspectFill
    }
    
    private func setupCollectionView() {
        view.addSubview(latestGroupsCollectionView)
        latestGroupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            latestGroupsCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            latestGroupsCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
            latestGroupsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            latestGroupsCollectionView.topAnchor.constraint(equalTo: userId.bottomAnchor, constant: 20)
        ])
    }
    
    /* Open user settings screen */
    @objc private func goToSettings() {
        viewModel.goToSettings()
    }
    
}
