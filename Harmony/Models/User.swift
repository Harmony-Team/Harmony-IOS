//
//  User.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

struct User: Codable {
    let username: String
    let email: String
    let password: String
}

struct LoginUser: Encodable {
    let username: String?
    let password: String?
}

struct SpotifyUser: Codable {
    let spotifyId: String
    let spotifyName: String
    let spotifyEmail: String
    let spotifyAccessToken: String
}

struct Req: Codable {
    let code: Int?
    
}
