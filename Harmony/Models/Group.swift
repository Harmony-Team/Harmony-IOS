//
//  Group.swift
//  Harmony
//
//  Created by Macbook Pro on 16.04.2021.
//

import Foundation

/* Group Response */
struct GroupsResponse: Codable {
    let response: [UserGroup]
}

/* New Group */
struct NewGroup: Codable {
    let code: Int?
    let invite_code: String
    let object: UserGroup
}

/* User's Group */
struct UserGroup: Codable {
    let avatar_url: String?
    let description: String?
    let hostLogin: String
    let id: Int
    let name: String
    let users: [GroupUsers]
}

/* Group Users */
struct GroupUsers: Codable {
    let login: String
}
