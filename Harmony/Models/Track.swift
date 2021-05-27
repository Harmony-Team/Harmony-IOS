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
    
    var artistsList: String {
        artists.map({ $0.name }).joined(separator: ", ")
    }
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


/* Pull Tracks Response */
struct PullTrackResponse: Codable {
    let response: [PullTrack]
}

/* Track In PULL */
struct PullTrack: Codable {
    let userLogin: String
    let spotifyTrackId: String
}

/* Extension To Spotify Tracks List To Filter It */
extension Array where Element == SpotifyTrack {
    func matching(_ text: String?) -> [SpotifyTrack] {
        if let text = text, text.count > 0 {
            return self.filter {
                return $0.name?.range(of: text, options: .caseInsensitive) != nil
            }
        } else {
            return self
        }
    }
}
