//
//  GroupAddUserCell.swift
//  Harmony
//
//  Created by Macbook Pro on 14.03.2021.
//

import UIKit

class GroupAddUserCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "AddGroupIdCell"
    let containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    let profileImageContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .bgColor
        return containerView
    }()
    
    let profilePicImageView: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13, *) {
            imageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        } else {
            imageView.image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        }
        imageView.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: -0.5, y: 1.5), endPoint: CGPoint(x: 1.5, y: -0.5), opacity: 1.0)
        imageView.tintColor = .redTextColor
        imageView.contentMode = .scaleAspectFit
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
        handle.text = "ADD A USER"
        return handle
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
    }
    
    internal func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageContainer)
        containerView.addSubview(profilePicImageView)
        contentView.addSubview(handleLabel)
    }
    
    private func setupCircles() {
        let containerHeight = containerView.bounds.height.rounded(.down)
        let profileContainerHeight = profileImageContainer.bounds.height.rounded(.down)
        containerView.layer.borderColor = UIColor.bgColor.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = containerHeight / 2
        profileImageContainer.layer.cornerRadius = profileContainerHeight / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = contentView.bounds
        containerView.frame.size = CGSize(width: containerView.frame.size.width - 15, height: containerView.frame.size.height - 15)
        
        profileImageContainer.frame = containerView.bounds
        profileImageContainer.frame.size = CGSize(width: containerView.bounds.width - 10, height: containerView.bounds.height - 10)
        profileImageContainer.center = containerView.center
        
        profilePicImageView.frame = containerView.bounds
        profilePicImageView.frame.size = CGSize(width: profileImageContainer.bounds.width * 0.3, height: profileImageContainer.bounds.height * 0.3)
        profilePicImageView.center = containerView.center
        
        handleLabel.frame = CGRect(x: 0, y: contentView.frame.maxY - 15, width: contentView.bounds.width, height: 20)
        handleLabel.center.x = containerView.center.x
        setupCircles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
