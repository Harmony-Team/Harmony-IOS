//
//  ErrorMusicTabBarCell.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class ErrorMusicTabBarCell: UICollectionViewCell {
    
    private var errorMsgLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear

    }
    
    func setupErrorLabel(errorMsg: String) {
        let attributedString = NSMutableAttributedString(string: errorMsg)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length)
        )

        errorMsgLabel.attributedText = attributedString
        errorMsgLabel.font = UIFont.setFont(size: .Big)
        errorMsgLabel.addKern(1.74)
        errorMsgLabel.numberOfLines = 3
        errorMsgLabel.textAlignment = .center
        errorMsgLabel.textColor = .white
        
        errorMsgLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(errorMsgLabel)
        
        NSLayoutConstraint.activate([
            errorMsgLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorMsgLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height * 0.3),
            errorMsgLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
