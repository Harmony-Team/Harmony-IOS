//
//  UITextField+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 06.02.2021.
//

import UIKit

extension UITextField {
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    
    func addPadding(_ padding: PaddingSide) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        
        switch padding {
        
        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always
            
        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
            
        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    /* Add bottom border */
    func addBottomBorder(height: CGFloat = 1.0, color: UIColor = .black) {
        let borderView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 3))

        borderView.setGradientStack(colorTop: UIColor.gradientColorTop.cgColor,
                                    colorBottom: UIColor.gradientColorBottom.cgColor,
                                    cornerRadius: 1)
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate(
            [
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: height)
            ]
        )
    }
    
    func setupLoginFormFields() {
       // self.addPadding(.both(15))
        self.font = UIFont.setFont(size: .Medium)
        self.defaultTextAttributes.updateValue(1.74, forKey: NSAttributedString.Key.kern)
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.cgColor,
            NSAttributedString.Key.kern: 1.74
        ])
    }
}
