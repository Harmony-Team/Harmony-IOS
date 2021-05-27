//
//  TrackImageView.swift
//  Harmony
//
//  Created by Macbook Pro on 21.03.2021.
//

import UIKit

fileprivate var imageCache = NSCache<NSString, UIImage>()

/* Custom Track Logo Image View */
class TrackImageView: UIImageView {
    
    var imageUrlString: String?
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        image = nil
        contentMode = mode
        imageUrlString = url.absoluteString
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let imageToCache = UIImage(data: data)
            imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async() {
                if self.imageUrlString == url.absoluteString {
                    self.image = imageToCache
                }
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        if let cachedImage = imageCache.object(forKey: link as NSString) {
            self.image = cachedImage
        } else {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }
}
