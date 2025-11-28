//
//  APIService.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

// MARK: - API Error
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - API Service
class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://ca024c0268fd1ff7adef.free.beeceptor.com/api/users"
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - GET All Users
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let users = try decoder.decode([User].self, from: data)
            return users
        } catch {
            // Try decoding as single object
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                return [user]
            } catch {
                throw APIError.decodingError(error)
            }
        }
    }
    
    // MARK: - GET Single User
    func fetchUser(id: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - POST Create User
    func createUser(_ user: User) async throws -> User {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(user)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let createdUser = try decoder.decode(User.self, from: data)
            return createdUser
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - PUT Update User (Full)
    func updateUser(id: String, user: User) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(user)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let updatedUser = try decoder.decode(User.self, from: data)
            return updatedUser
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - PATCH Update User (Partial)
    func patchUser(id: String, updates: [String: Any]) async throws -> User {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONSerialization.data(withJSONObject: updates)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let updatedUser = try decoder.decode(User.self, from: data)
            return updatedUser
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // MARK: - DELETE User
    func deleteUser(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        try validateResponse(response)
    }
    
    // MARK: - Helper Methods
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
    }
}

