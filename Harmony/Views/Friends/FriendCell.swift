//
//  FriendCell.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class FriendCell: UITableViewCell {
    
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var infoLabel = UILabel()
    var checkImageView = UIImageView()
    var addFriendButton = UIButton()
    
    override var isSelected: Bool {
        didSet {
            checkImageView.image = isSelected ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
            addFriendButton.backgroundColor = isSelected ? .white : .mainColor
            addFriendButton.titleLabel?.textColor = isSelected ? .gray : .white
            addFriendButton.setTitle(isSelected ? "Added" : "Add", for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        avatarImageView.backgroundColor = .lightGray
        avatarImageView.layer.cornerRadius = 25
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        infoLabel.font = .systemFont(ofSize: 16, weight: .medium)
        infoLabel.textColor = .gray
        
        checkImageView.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
        checkImageView.tintColor = .mainColor
        
        addFriendButton.setTitle("Add", for: .normal)
        addFriendButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        addFriendButton.titleLabel?.textColor = .white
        addFriendButton.backgroundColor = .mainColor
        addFriendButton.layer.cornerRadius = 15
        
        [avatarImageView, nameLabel, infoLabel, checkImageView, addFriendButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(checkImageView)
        contentView.addSubview(addFriendButton)
    }
    
    private func setupLayouts() {
        avatarImageView.pinToEdges(edges: [.left, .top], constant: 15)
        nameLabel.pinToEdges(edges: [.top], constant: 15)
        checkImageView.pinToEdges(edges: [.right], constant: 15)
        addFriendButton.pinToEdges(edges: [.right], constant: 15)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            infoLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            checkImageView.widthAnchor.constraint(equalTo: checkImageView.heightAnchor),
            
            addFriendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addFriendButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            addFriendButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
