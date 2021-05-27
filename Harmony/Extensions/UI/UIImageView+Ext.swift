//
//  UIImageView+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 11.03.2021.
//

import UIKit

extension UIImageView {
    func setupTopGradientMask(with topView: UIView) {
        
        self.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: -0.5, y: 1.0), endPoint: CGPoint(x: 1.8, y: 0.8), opacity: 0.75)
        topView.setGradientFill(colorTop: UIColor.gradientColorTop.cgColor, colorBottom: UIColor.gradientColorBottom.cgColor, cornerRadius: 0, startPoint: CGPoint(x: 0.0, y: 1.0), endPoint: CGPoint(x: 1.0, y: 0.0), opacity: 1)
        
        addImageMask(imageView: self)
        addViewMask(imageView: self, topView: topView)
    }
    
    /* Adding Image Mask */
    func addImageMask(imageView: UIView) {
        let path = UIBezierPath()

        //Move to Top Left
        path.move(to: .init(x: 0, y: 0))

        //Draw line from Top Left to Top Right
        path.addLine(to: .init(x: imageView.bounds.size.width, y: 0))

        //Draw Line from Top Right to Bottom Right
        path.addLine(to: .init(x: imageView.bounds.size.width, y: imageView.bounds.size.height * 0.75))
        
        //Draw Curved Line from Bottom Right to Bottom Left
        path.addCurve(to: .init(x: 0, y: imageView.bounds.size.height * 0.7),
                      controlPoint1: .init(x: UIScreen.main.bounds.width * 2/3, y: imageView.bounds.size.height * 0.45),
                      controlPoint2: .init(x: UIScreen.main.bounds.width * 0.6, y: imageView.bounds.size.height * 1.2))

        //Close Path
        path.close()

        //Create the Shape Mask for the ImageView
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor

        imageView.layer.mask = shapeLayer
    }
    
    /* Adding Another Mask */
    func addViewMask(imageView: UIView, topView: UIView) {
        let path = UIBezierPath()

        //Move to Top Left
        path.move(to: .init(x: 0, y: 0))

        //Draw line from Top Left to Top Right
        path.addLine(to: .init(x: imageView.bounds.size.width, y: 0))

        //Draw Line from Top Right to Bottom Right
        path.addLine(to: .init(x: imageView.bounds.size.width, y: imageView.bounds.size.height * 0.9))
        
        //Draw Curved Line from Bottom Right to Bottom Left
        path.addCurve(to: .init(x: 0, y: imageView.bounds.size.height * 0.9),
                      controlPoint1: .init(x: UIScreen.main.bounds.width * 0.4, y: imageView.bounds.size.height * 0.2),
                      controlPoint2: .init(x: UIScreen.main.bounds.width * 0.1, y: imageView.bounds.size.height * 1))

        //Close Path
        path.close()

        //Create the Shape Mask for the ImageView
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.yellow.cgColor
        topView.layer.mask = shapeLayer
//        imageView.layer.mask = shapeLayer
    }
}

extension UIImage {
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
    
    /* Encoding Image To Base64 String */
    func imageToBase64() -> String {
        let imageData: Data = self.jpegData(compressionQuality: 1)! as Data
        let strBase64: String = imageData.base64EncodedString(options: .lineLength64Characters).replacingOccurrences(of: " ", with: "%20")
        
        return strBase64
    }
    
    func imageFromBase64(_ base64: String) -> UIImage? {
        if let url = URL(string: base64) {
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}
