//
//  User.swift
//  Harmony
//
//  Created by Macbook Pro on 07.02.2021.
//

import UIKit

/* User Response */
struct UserResponse: Codable {
    let response: [User]
}

/* User Role */
enum Role: String, Codable {
    case USER, DEV
}

/* User Status */
enum Status: String, Codable {
    case ACTIVE, BANNED
}

/* User */
struct User: Codable {
    let dateCreated: String
    let login: String
    let email: String
    let role: Role
    let status: Status
    let okId: String?
    let spotifyId: String?
    let vkId: String?
}

/* Register User */
struct RegisterUser: Codable {
    let login: String
    let email: String
    let password: String
}

/* Login User */
struct LoginUser: Codable {
    let username: String?
    let password: String?
}

/* Spotify User */
struct SpotifyUser: Codable {
    let spotifyId: String
    let spotifyName: String
    let spotifyEmail: String
    let spotifyAccessToken: String
}

struct Req: Codable {
    let code: Int?
}
