//
//  UILabel+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 22.02.2021.
//

import UIKit

extension UILabel {
    func addKern(_ kernValue: CGFloat) {
        guard let attributedText = attributedText,
            attributedText.string.count > 0,
            let fullRange = attributedText.string.range(of: attributedText.string) else {
                return
        }
        let updatedText = NSMutableAttributedString(attributedString: attributedText)
        updatedText.addAttributes([
            .kern: kernValue
            ], range: NSRange(fullRange, in: attributedText.string))
        self.attributedText = updatedText
    }
    
    /* Text Changing Animation */
    func animateTextChange(duration: CGFloat, newText: String) {
        UIView.transition(with: self, duration: TimeInterval(duration), options: .transitionCrossDissolve, animations: {
            self.text = newText
        })
    }
}
