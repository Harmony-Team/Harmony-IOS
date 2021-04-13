//
//  RecentActivityCell.swift
//  Harmony
//
//  Created by Macbook Pro on 07.04.2021.
//

import UIKit

class RecentActivityCell: UICollectionViewCell {
    
    private var label = UILabel()
    private var timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        setupViews()
        setupLayouts()
    }
    
    func update(viewModel: RecentActivityCellViewModel) {
        let attr = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let redAttr = [NSAttributedString.Key.foregroundColor: UIColor.redTextColor]
        let part1 = NSMutableAttributedString(string: "\(viewModel.userName) followed ", attributes: attr)
        
        for (idx, name) in viewModel.usersFollowed.enumerated() {
            let part2 = NSMutableAttributedString(string: "\(name)", attributes: redAttr)
            part1.append(part2)

            if idx == viewModel.usersFollowed.count - 1 {
                part1.append(NSAttributedString(string: " & ", attributes: attr))
                part1.append(NSAttributedString(string: "two others", attributes: redAttr))
                part1.append(NSAttributedString(string: ".", attributes: attr))
            } else {
                part1.append(NSAttributedString(string: ", ", attributes: attr))
            }
        }
        label.attributedText = part1
        timeLabel.text = viewModel.timeString
    }
    
    private func setupViews() {
//        label.text = "Iuser followed Nathan Hunt, Carolyne Miller & two others."
        label.numberOfLines = 0
        label.font = UIFont.setFont(size: .Large, weight: .Light)
        label.addKern(1.5)
        label.textAlignment = .center
        
        timeLabel.font = UIFont.setFont(size: .Medium)
        timeLabel.addKern(1.5)
        timeLabel.textAlignment = .center
        timeLabel.textColor = .mainTextColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(timeLabel)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),
            timeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
