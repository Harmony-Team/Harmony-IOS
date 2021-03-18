//
//  SpotifyAuthResponse.swift
//  Harmony
//
//  Created by Macbook Pro on 04.03.2021.
//

import Foundation

struct SpotifyAuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}


struct SpotifyUserIntegration: Encodable {
    var spotifyId: String
    var accessToken: String
    var refreshToken: String
}
