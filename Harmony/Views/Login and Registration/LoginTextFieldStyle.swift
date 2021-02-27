//
//  LoginTextFieldStyle.swift
//  Harmony
//
//  Created by Macbook Pro on 03.02.2021.
//

import UIKit

@IBDesignable class LoginTextFieldStyle: UITextField {
    
    @IBInspectable var fontSize: CGFloat = 14 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        setupFont()
        
        self.defaultTextAttributes.updateValue(1.74, forKey: NSAttributedString.Key.kern)
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.cgColor,
            NSAttributedString.Key.kern: 1.74
        ])
    }
    
    func setupFont() {
        guard let customFont = UIFont(name: "Lato-Regular", size: fontSize) else {
            fatalError("""
                Failed to load the "Lato-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        self.font = UIFontMetrics.default.scaledFont(for: customFont)
    }
    
}
