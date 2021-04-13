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
    var rightSwitcher = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    private func setupViews() {
        leftLabel.font = UIFont.setFont(size: .Large)
        leftLabel.addKern(1.74)
        leftLabel.textColor = .white
        
        rightLabel.font = UIFont.setFont(size: .Small)
        rightLabel.textColor = .mainTextColor
        
        [leftLabel, rightLabel, rightSwitcher].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(rightSwitcher)
    }
    
    private func setupLayouts() {
        leftLabel.pinToEdges(edges: [.left], constant: contentView.frame.width * 0.1)
        rightLabel.pinToEdges(edges: [.right], constant: contentView.frame.width * 0.1)
        rightSwitcher.pinToEdges(edges: [.right], constant: contentView.frame.width * 0.1)
        
        NSLayoutConstraint.activate([
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightSwitcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
