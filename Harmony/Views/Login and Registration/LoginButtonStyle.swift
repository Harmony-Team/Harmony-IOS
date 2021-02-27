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
        self.setupShadow(cornerRad: 5, shadowRad: 5, shadowOp: 0.5, offset: CGSize(width: 0, height: 5))
    }

}
