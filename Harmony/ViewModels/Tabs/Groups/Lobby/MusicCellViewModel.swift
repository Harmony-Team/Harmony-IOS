//
//  MusicCellViewModel.swift
//  Harmony
//
//  Created by Macbook Pro on 17.02.2021.
//

import UIKit

class MusicCellViewModel {
    private var imageCache = NSCache<NSString, UIImage>()
    private var cacheKey: String {
        track.name
    }
    
    var trackName: String? {
        track.name
    }
    
    var trackArtistName: String? {
        track.artists[0].name
    }
    
    var trackImage: String? {
        track.album.images[0].url
    }
    
    // Cache images
    func loadTrackImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
        } else {
            let url = URL(string: track.album.images[0].url)!
            print(url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async() {
                    guard let image = UIImage(data: data) else {return}
                    self.imageCache.setObject(image, forKey: self.cacheKey as NSString)
                    completion(image)
                }
            }
            
        }
    }
    
    var track: Track
    init(track: Track) {
        self.track = track
    }
}
