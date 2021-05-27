//
//  MenuSectionsCell.swift
//  Harmony
//
//  Created by Macbook Pro on 13.04.2021.
//

import UIKit

class MenuSectionsCell: UITableViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "MenuSectionsCellId"
    var sectionNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        setupHierarchy()
    }
    
    override var isSelected: Bool {
        didSet {
            sectionNameLabel.font = UIFont.setFont(size: .Largest, weight: isSelected ? .Bold : .Light)
        }
    }
    
    internal func setupViews() {
        sectionNameLabel.text = "Test"
        sectionNameLabel.font = UIFont.setFont(size: .Largest, weight: .Light)
        sectionNameLabel.addKern(1.5)
        sectionNameLabel.textColor = .white
        sectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy() {
        addSubview(sectionNameLabel)
        
        NSLayoutConstraint.activate([
            sectionNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            sectionNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
