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
