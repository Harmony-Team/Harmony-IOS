//
//  GroupCell.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

class GroupCell: UITableViewCell {
    
    var logoImageView = UIImageView()
    var titleLabel = UILabel()
    var msgLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        logoImageView.backgroundColor = .lightGray
        logoImageView.layer.cornerRadius = 25
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        
        msgLabel.font = .systemFont(ofSize: 16, weight: .medium)
        msgLabel.textColor = .gray
        
        [logoImageView, titleLabel, msgLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(msgLabel)
    }
    
    private func setupLayouts() {
        logoImageView.pinToEdges(edges: [.left, .top], constant: 15)
        titleLabel.pinToEdges(edges: [.top], constant: 15)
        
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 15),
            
            msgLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            msgLabel.leftAnchor.constraint(equalTo: logoImageView.rightAnchor, constant: 15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
