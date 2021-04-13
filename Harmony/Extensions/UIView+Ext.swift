//
//  UIView+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 05.02.2021.
//

import UIKit

extension UIView {
    
    enum Edge {
        case top
        case bottom
        case left
        case right
    }

    func pinToEdges(edges: [Edge] = [.top, .bottom, .left, .right], constant: CGFloat = 0) {
        guard let superview = superview else {return}
        edges.forEach {
            switch $0 {
            case .top:
                topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            case .left:
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant).isActive = true
            case .right:
                rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant).isActive = true
            }
        }
    }
    
    func setupShadow(cornerRad: CGFloat, shadowRad: CGFloat, shadowOp: Float, offset: CGSize) {
        self.layer.cornerRadius = cornerRad
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRad
        self.layer.shadowOpacity = shadowOp
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /* Setting gradient for fields stack */
    func setGradientStack(colorTop: CGColor, colorBottom: CGColor, cornerRadius: CGFloat, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [
            colorBottom,
            colorTop
        ]

        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    /* Setting gradient for fields stack */
    func setGradientFill(colorTop: CGColor, colorBottom: CGColor, cornerRadius: CGFloat, startPoint: CGPoint, endPoint: CGPoint, opacity: Float) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom, colorTop]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.opacity = opacity
        gradientLayer.frame = self.bounds
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /* Shake Animation After Form Error */
    func shakeAnimation(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func setVerificationIcon() {
        let bgViewWidth = frame.width * 0.25
        let bgView = UIView(frame: CGRect(x: frame.width - bgViewWidth - 5, y: 5, width: bgViewWidth, height: bgViewWidth))
        let starIcon = UIImageView()
        
        starIcon.image = UIImage(named: "starIcon")
        starIcon.contentMode = .scaleAspectFill
        starIcon.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = .redTextColor
        bgView.layer.cornerRadius = bgViewWidth / 2
        bgView.layer.zPosition = 3
        
        addSubview(bgView)
        bgView.addSubview(starIcon)
        
        starIcon.pinToEdges(constant: 7)
    }
}
