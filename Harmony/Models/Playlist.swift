//
//  Playlist.swift
//  Harmony
//
//  Created by Macbook Pro on 14.02.2021.
//

import Foundation

struct Playlists: Codable {
    var items: [Playlist]
}

struct Playlist: Codable {
    var id: String
    var name: String
    var tracks: Tracks
}
