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
    func setGradientStack(colorTop: CGColor, colorBottom: CGColor, cornerRadius: CGFloat) {
//        let colorTop = UIColor.toRGB(red: 255, green: 38, blue: 98, alpha: 1).cgColor
//        let colorBottom = UIColor.toRGB(red: 61, green: 38, blue: 158, alpha: 1) .cgColor
//        
//                let gradientLayer = CAGradientLayer()
//                gradientLayer.colors = [colorBottom, colorTop]
//                        gradientLayer.startPoint = CGPoint(x: -0.5, y: 1.1)
//                        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
//                gradientLayer.frame = fieldsStack.bounds
//        
//                fieldsView.layer.masksToBounds = true
//                fieldsView.layer.cornerRadius = 15
//                fieldsView.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.colors = [
            colorBottom,
            colorTop
        ]
        gradient.startPoint = CGPoint(x: -0.5, y: 1.1)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
}

fileprivate var imageCache = NSCache<NSString, UIImage>()
fileprivate var cacheKey: String!

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                imageCache.setObject(image, forKey: cacheKey as NSString)
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        cacheKey = link
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }
}
