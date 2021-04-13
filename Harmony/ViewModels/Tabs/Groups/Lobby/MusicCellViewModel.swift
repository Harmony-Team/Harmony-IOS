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
        track.name!
    }
    
    var trackName: String? {
        track.name
    }
    
    var trackArtistName: String? {
        track.artist
    }
    
    var trackImage: String? {
        track.image_url
    }
    
    // Cache images
    func loadTrackImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
        } else {
            let url = URL(string: track.image_url!)!
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
    
    var track: SpotifyTrack
    init(track: SpotifyTrack) {
        self.track = track
    }
}
