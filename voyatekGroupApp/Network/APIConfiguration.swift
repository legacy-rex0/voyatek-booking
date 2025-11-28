//
//  APIConfiguration.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

// MARK: - API Configuration
struct APIConfiguration {
    static let baseURL = "https://voyatek-tst.free.beeceptor.com/api"
    
    // MARK: - Endpoints
    enum Endpoint {
        case trips
        case trip(id: String)
        case users
        case user(id: String)
        
        var path: String {
            switch self {
            case .trips:
                return "/trips"
            case .trip(let id):
                return "/trips/\(id)"
            case .users:
                return "/users"
            case .user(let id):
                return "/users/\(id)"
            }
        }
        
        var url: URL? {
            return URL(string: APIConfiguration.baseURL + path)
        }
    }
}

