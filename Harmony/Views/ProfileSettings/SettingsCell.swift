//
//  SettingsCell.swift
//  Harmony
//
//  Created by Macbook Pro on 12.02.2021.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    var leftLabel = UILabel()
    var rightLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        leftLabel.font = .systemFont(ofSize: 18, weight: .medium)
        leftLabel.textColor = .darkTextColor
        
        rightLabel.font = .systemFont(ofSize: 18)
        rightLabel.textColor = .gray
        
        [leftLabel, rightLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
    }
    
    private func setupLayouts() {
        leftLabel.pinToEdges(edges: [.left], constant: 15)
        rightLabel.pinToEdges(edges: [.right], constant: 15)
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
