//
//  GroupCell.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class GroupCell: UITableViewCell {
    
    var logoView = UIView()
    var logoImageView = UIImageView()
    var verticalStack = UIStackView()
    var titleLabel = UILabel()
    var msgLabel = UILabel()
    var separatorLine = UIView()
    var imagePadding: CGFloat?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        logoView.setupShadow(cornerRad: 10, shadowRad: 5, shadowOp: 0.3, offset: CGSize(width: 3, height: 5))
        
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.tintColor = .white
        
        titleLabel.font = UIFont.setFont(size: .Large)
        titleLabel.textColor = .white
        
        msgLabel.font = UIFont.setFont(size: .Medium)
        msgLabel.textColor = .lightTextColor
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 5
        
        separatorLine.backgroundColor = .gray
        separatorLine.alpha = 0.3
        
        [logoView, logoImageView, titleLabel, msgLabel, verticalStack, separatorLine].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(logoView)
        logoView.addSubview(logoImageView)
        contentView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(msgLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func setupLayouts() {
        logoView.pinToEdges(edges: [.left], constant: contentView.frame.height * 2/5)
        logoImageView.pinToEdges(constant: 0)

        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/5),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
            logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: contentView.frame.height * 2/5),
            
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
