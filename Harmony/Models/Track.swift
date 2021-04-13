//
//  Track.swift
//  Harmony
//
//  Created by Macbook Pro on 16.02.2021.
//

import Foundation

/* Tracks for playlist */
struct Tracks: Codable {
    var href: String
}

/* Tracks */
struct TracksList: Codable {
    var items: [TrackItem]
}

/* Track Item */
struct TrackItem: Codable {
    var track: Track
}

/* Cur. Track */
struct Track: Codable {
    var album: Album
    var artists: [Artist]
    var name: String
    var id: String
    
}

/* Track Artist */
struct Artist: Codable {
    var name: String
}

struct Album: Codable {
    var images: [AlbumImage]
}

struct AlbumImage: Codable {
    var url: String
}
