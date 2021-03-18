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
    
    let profilePicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .bgColor
        imageView.image = UIImage(named: "groupImage")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let handleLabel: UILabel = {
        let handle = UILabel()
        handle.textAlignment = .center
        handle.font = UIFont.setFont(size: .Small)
        handle.textColor = .white
        handle.addKern(1.74)
        handle.text = "VIKTOR"
        return handle
    }()
    
    var isAdmin: Bool?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(profilePicImageView)
        contentView.addSubview(handleLabel)
    }
    
    private func setupCircles() {
        let containerHeight = containerView.bounds.height.rounded(.down)
        let profilePictureHeight = profilePicImageView.bounds.height.rounded(.down)
        if let admin = isAdmin, admin {
            containerView.setGradientStack(colorTop: UIColor.redTextColor.cgColor, colorBottom: UIColor.black.cgColor, cornerRadius: containerHeight / 2, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0))
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
        containerView.frame.size = CGSize(width: containerView.frame.size.width - 15, height: containerView.frame.size.height - 15)
        profilePicImageView.frame = containerView.bounds
        profilePicImageView.frame.size = CGSize(width: containerView.bounds.width - 10, height: containerView.bounds.height - 10)
        profilePicImageView.center = containerView.center
        handleLabel.frame = CGRect(x: 0, y: contentView.frame.maxY - 15, width: contentView.bounds.width, height: 20)
        handleLabel.center.x = containerView.center.x
        setupCircles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
