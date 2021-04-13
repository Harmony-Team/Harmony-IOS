//
//  FriendCell.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class FriendCell: UITableViewCell {
    
    var avatarView = UIView()
    var avatarImageView = UIImageView()
    var verticalStack = UIStackView()
    var nameLabel = UILabel()
    var infoLabel = UILabel()
    var separatorLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        
        avatarView.setupShadow(cornerRad: 0, shadowRad: 5, shadowOp: 0.3, offset: CGSize(width: 3, height: 5))
        
        avatarImageView.image = UIImage(named: "groupImage1")
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = UIScreen.main.bounds.height * 0.13 / 4
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        
        nameLabel.font = UIFont.setFont(size: .Large)
        nameLabel.textColor = .white
        nameLabel.addKern(1.74)
        
        infoLabel.font = UIFont.setFont(size: .Medium)
        infoLabel.textColor = .lightTextColor
        infoLabel.addKern(1.74)
        
        separatorLine.backgroundColor = .gray
        separatorLine.alpha = 0.3
        
        [avatarView, avatarImageView, verticalStack, nameLabel, infoLabel, separatorLine].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(avatarView)
        avatarView.addSubview(avatarImageView)
        contentView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(nameLabel)
        verticalStack.addArrangedSubview(infoLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func setupLayouts() {
        avatarView.pinToEdges(edges: [.left], constant: contentView.frame.height * 2/5)
        avatarImageView.pinToEdges(constant: 0)
        
        NSLayoutConstraint.activate([
            
            avatarView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: contentView.frame.height * 2/5),
            
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separatorLine.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
