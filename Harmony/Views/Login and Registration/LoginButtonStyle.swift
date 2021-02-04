//
//  UIButton+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 02.02.2021.
//

import UIKit

class LoginButtonStyle: UIButton {
 
    override func awakeFromNib() {
        super.awakeFromNib()
 
        self.layer.cornerRadius = 20
        self.tintColor = .white
        self.setupShadow()
    }
    
    func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
