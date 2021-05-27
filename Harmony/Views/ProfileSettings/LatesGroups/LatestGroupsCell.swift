//
//  LatestGroupsCollectionViewCell.swift
//  Harmony
//
//  Created by Macbook Pro on 10.03.2021.
//

import UIKit

class LatestGroupsCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "LatestGroupIdCell"
    var logoView = UIView()
    var groupLogo = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayouts()
    }
    
    internal func setupViews() {
        
        logoView.frame = contentView.frame
        logoView.setupShadow(cornerRad: contentView.frame.width / 2, shadowRad: 5, shadowOp: 0.1, offset: CGSize(width: 3, height: 5))
        
        groupLogo.image = UIImage(named: "groupImage")
        groupLogo.contentMode = .scaleAspectFill
        groupLogo.layer.masksToBounds = true
        groupLogo.layer.cornerRadius = contentView.frame.width / 2
        logoView.translatesAutoresizingMaskIntoConstraints = false
        groupLogo.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(logoView)
        logoView.addSubview(groupLogo)
    }
    
    private func setupLayouts() {
        groupLogo.frame = logoView.frame
//        NSLayoutConstraint.activate([
//            groupLogo.frame = conte
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
