//
//  TabBar+Ext.swift
//  Harmony
//
//  Created by Macbook Pro on 01.02.2021.
//

import UIKit

extension UITabBar {
    
    func addShape(shapeLayer: inout CAShapeLayer, layer: inout CALayer?) {
        
        if shapeLayer.animation(forKey: "pathAnimation") == nil {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = createLinePath()
            pathAnimation.toValue = createPath()
            pathAnimation.duration = 0.1
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathAnimation.fillMode = CAMediaTimingFillMode.forwards
            pathAnimation.isRemovedOnCompletion = false

            shapeLayer.add(pathAnimation, forKey: "pathAnimation")
        }
        
        self.layer.insertSublayer(shapeLayer, at: 0)

        if let oldShapeLayer = layer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        layer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let height: CGFloat = 86.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
//        path.addQuadCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
//                          controlPoint: CGPoint(x: centerWidth, y: height - 40))
        path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
                      controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
        
//        path.addCurve(to: CGPoint(x: centerWidth, y: 0),
//                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
//                      controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40),
                      controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: 0, y: self.frame.maxY))
        path.close()
        
        return path.cgPath
    }

    func removeShape(shapeLayer: inout CAShapeLayer, layer: inout CALayer?) {
        
        if layer == nil {
            shapeLayer.path = createLinePath()
            self.layer.insertSublayer(shapeLayer, at: 0)

            if let oldShapeLayer = layer {
                self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            } else {
                self.layer.insertSublayer(shapeLayer, at: 0)
            }
            layer = shapeLayer
        } else {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = createPath()
            pathAnimation.toValue = createLinePath()
            pathAnimation.duration = 0.3
            pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            pathAnimation.fillMode = CAMediaTimingFillMode.forwards
            pathAnimation.isRemovedOnCompletion = false

            shapeLayer.removeAnimation(forKey: "pathAnimation")
            shapeLayer.add(pathAnimation, forKey: "pathLineAnimation")
        }
    }
    
    func createLinePath() -> CGPath {
        let height: CGFloat = 86.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - height ), y: 0))
//        path.addQuadCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
//                          controlPoint: CGPoint(x: centerWidth, y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: 0),
                      controlPoint1: CGPoint(x: centerWidth, y: 0),
                      controlPoint2: CGPoint(x: centerWidth, y: 0))
        
//        path.addCurve(to: CGPoint(x: centerWidth, y: 0),
//                      controlPoint1: CGPoint(x: centerWidth, y: 0),
//                      controlPoint2: CGPoint(x: centerWidth, y: 0))
        
        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint1: CGPoint(x: (centerWidth + height ), y: 0),
                      controlPoint2: CGPoint(x: (centerWidth + height ), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.maxY))
        path.addLine(to: CGPoint(x: 0, y: self.frame.maxY))
        path.close()
        return path.cgPath
    }
}
