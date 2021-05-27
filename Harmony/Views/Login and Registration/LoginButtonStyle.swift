//
//  UIButton+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 02.02.2021.
//

import UIKit

class LoginButtonStyle: UIButton {
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        configure()
//    }
//
//    convenience init(title: String, titleColor: UIColor, fontSize: FontSize) {
//        self.init(frame: .zero)
//        self.setTitle(title, for: .normal)
//        self.setTitleColor(titleColor, for: .normal)
//        self.titleLabel?.font = UIFont.setFont(size: fontSize)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        configure()
    }
    
    private func configure() {
        titleLabel?.font = UIFont.setFont(size: .Small)
        titleLabel?.addKern(1.74)
        layer.cornerRadius = 20
        tintColor = .white
        setupShadow(cornerRad: 5, shadowRad: 5, shadowOp: 0.5, offset: CGSize(width: 0, height: 5))
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
