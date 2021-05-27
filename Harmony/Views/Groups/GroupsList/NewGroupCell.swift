//
//  NewGroupCell.swift
//  Harmony
//
//  Created by Macbook Pro on 09.03.2021.
//

import UIKit

class NewGroupCell: UITableViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "NewGroupIdCell"
    var logoView = UIView()
    var logoImageView = UIImageView()
    var titleLabel = UILabel()
    var separatorLine = UIView()
    var imagePadding: CGFloat?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        setupViews()
        setupHierarchy()
        setupLayouts()
    }
    
    internal func setupViews() {
        let cellHeight: CGFloat = UIScreen.main.bounds.height * 0.15
        logoView.frame.size = CGSize(width: cellHeight * 3/5, height: cellHeight * 3/5)
        logoView.setupShadow(cornerRad: 10, shadowRad: 5, shadowOp: 0.6, offset: CGSize(width: 0, height: 5))
        logoView.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 15, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
        if #available(iOS 13, *) {
            logoImageView.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        } else {
            logoImageView.image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        }
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.tintColor = .white
        
        titleLabel.font = UIFont.setFont(size: .Large, weight: .Light)
        titleLabel.textColor = .redTextColor
        
        separatorLine.backgroundColor = .gray
        separatorLine.alpha = 0.3
        
        [logoView, logoImageView, titleLabel, separatorLine].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    private func setupHierarchy() {
        contentView.addSubview(logoView)
        logoView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func setupLayouts() {
        logoView.pinToEdges(edges: [.left], constant: contentView.frame.height * 2/5)
        logoImageView.pinToEdges(constant: 20)

        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 3/5),
            logoView.widthAnchor.constraint(equalTo: logoView.heightAnchor),
            logoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: contentView.frame.height * 2/5),
            
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
