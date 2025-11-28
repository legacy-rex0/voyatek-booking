//
//  User.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

// MARK: - User Model
struct User: Codable, Identifiable, Hashable {
    let id: String?
    var name: String
    var email: String
    var phone: String?
    var address: String?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case address
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    // Initializer for creating new users
    init(name: String, email: String, phone: String? = nil, address: String? = nil) {
        self.id = nil
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    // Full initializer for API responses
    init(id: String?, name: String, email: String, phone: String?, address: String?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - API Response Models
struct UsersResponse: Codable {
    let users: [User]?
    
    // Handle both array and object responses
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let users = try? container.decode([User].self) {
            self.users = users
        } else if let user = try? container.decode(User.self) {
            self.users = [user]
        } else {
            self.users = []
        }
    }
}

