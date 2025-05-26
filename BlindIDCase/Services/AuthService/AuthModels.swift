//
//  AuthModels.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation

// MARK: - Response Models

struct AuthResponse: Decodable {
    let message: String?
    let token: String?
    let user: User?
}

struct User: Decodable, Identifiable {
    let id: String?
    let name: String?
    let surname: String?
    let email: String?
}

struct CurrentUser: Decodable, Identifiable {
    let id: String?
    let name: String?
    let surname: String?
    let email: String?
    let likedMovies: [Int]?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case surname
        case email
        case likedMovies
        case createdAt
        case updatedAt
        case version = "__v"
    }

    init(from user: User) {
        self.id = user.id
        self.name = user.name
        self.surname = user.surname
        self.email = user.email
        self.likedMovies = []
        self.createdAt = ""
        self.updatedAt = ""
        self.version = 0
    }
}

struct ProfileUpdateResponse: Decodable {
    let message: String?
    let user: User?
}
