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
    let dateCreated: Int?
    let login: String
    let email: String
    let role: Role
    let status: Status
    let spotify: String?
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

/* User Services */
struct ServiceIntergration: Codable {
    let spotify: String
}

/* Spotify User */
struct SpotifyUser: Codable {
    var spotifyId: String
    var spotifyName: String
    var spotifyEmail: String
    var spotifyAccessToken: String
}

struct Req: Codable {
    let code: Int?
}
