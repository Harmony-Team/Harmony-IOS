//
//  GroupUsersCell.swift
//  Harmony
//
//  Created by Macbook Pro on 11.03.2021.
//

import UIKit

class GroupUsersCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    let profilePicImageView = UIImageView()
    let userName = UILabel()
    
    var isAdmin = false
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    func update(viewModel: GroupUsersCellViewModel) {
        userName.text = viewModel.userName.uppercased()
        viewModel.loadUserImage { [weak self] image in
            self?.profilePicImageView.image = image
        }
    }
    
    private func setupViews() {
        userName.textAlignment = .center
        userName.font = UIFont.setFont(size: .Small)
        userName.textColor = .white
        userName.addKern(1.74)
        
        profilePicImageView.backgroundColor = .bgColor
        profilePicImageView.image = UIImage(named: "groupImage")
        profilePicImageView.contentMode = .scaleAspectFill
        profilePicImageView.clipsToBounds = true
        profilePicImageView.isUserInteractionEnabled = true
        
        contentView.addSubview(containerView)
        containerView.addSubview(profilePicImageView)
        contentView.addSubview(userName)
    }
    
    private func setupCircles() {
        let containerHeight = containerView.bounds.height.rounded(.down)
        let profilePictureHeight = profilePicImageView.bounds.height.rounded(.down)
        if isAdmin {
            containerView.setGradientStack(colorTop: UIColor.redTextColor.cgColor, colorBottom: UIColor.black.cgColor, cornerRadius: containerHeight / 2, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0))
            containerView.setVerificationIcon()
        } else {
            containerView.layer.borderColor = UIColor.white.cgColor
            containerView.layer.borderWidth = 1
            containerView.layer.cornerRadius = containerHeight / 2
        }
        profilePicImageView.layer.cornerRadius = profilePictureHeight / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = contentView.bounds
        containerView.frame.size = CGSize(width: containerView.frame.size.width - 15, height: containerView.frame.size.height * 0.85)
        profilePicImageView.frame = containerView.bounds
        profilePicImageView.frame.size = CGSize(width: containerView.bounds.width - 10, height: containerView.bounds.width - 10)
        profilePicImageView.center = containerView.center
        userName.frame = CGRect(x: 0, y: contentView.frame.maxY - 15, width: contentView.bounds.width, height: 20)
        userName.center.x = containerView.center.x
        setupCircles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
