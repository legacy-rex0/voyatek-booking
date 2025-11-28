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
    
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Trips API
    
    /// Fetch all trips
    func fetchTrips() async throws -> [Trip] {
        guard let url = APIConfiguration.Endpoint.trips.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        try validateResponse(response)
        
        // Log raw response for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
        // Handle empty response
        if data.isEmpty {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            // Try to decode as array first
            let trips = try decoder.decode([Trip].self, from: data)
            return trips
        } catch let arrayError {
            // Try decoding as wrapped object (e.g., { "data": [...] })
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataArray = json["data"] as? [[String: Any]] {
                    let decoder = JSONDecoder()
                    let tripsData = try JSONSerialization.data(withJSONObject: dataArray)
                    let trips = try decoder.decode([Trip].self, from: tripsData)
                    return trips
                }
            } catch {
                // Continue to try single object
            }
            
            // Try decoding as single object
            do {
                let decoder = JSONDecoder()
                let trip = try decoder.decode(Trip.self, from: data)
                return [trip]
            } catch let singleError {
                // Log detailed error information
                print("Array decode error: \(arrayError)")
                if let decodingError = arrayError as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
                print("Single decode error: \(singleError)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to decode JSON: \(jsonString)")
                }
                throw APIError.decodingError(arrayError)
            }
        }
    }
    
    /// Fetch a single trip by ID
    func fetchTrip(id: String) async throws -> Trip {
        guard let url = APIConfiguration.Endpoint.trip(id: id).url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            let trip = try decoder.decode(Trip.self, from: data)
            return trip
        } catch let error {
            // Log detailed error
            if let decodingError = error as? DecodingError {
                print("Decoding error details: \(decodingError)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Failed to decode JSON: \(jsonString)")
            }
            throw APIError.decodingError(error)
        }
    }
    
    /// Create a new trip
    func createTrip(_ trip: Trip) async throws -> Trip {
        guard let url = APIConfiguration.Endpoint.trips.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        // Log request body for debugging
        let requestBody = try encoder.encode(trip)
        if let jsonString = String(data: requestBody, encoding: .utf8) {
            print("POST Request Body: \(jsonString)")
        }
        request.httpBody = requestBody
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        // Handle empty response (some APIs return 201 with no body)
        if data.isEmpty {
            // Return the trip we sent (with potentially updated ID from server)
            return trip
        }
        
        // Log response for debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("POST Response: \(jsonString)")
        }
        
        do {
            let decoder = JSONDecoder()
            let createdTrip = try decoder.decode(Trip.self, from: data)
            return createdTrip
        } catch let decodeError {
            // Log detailed error
            print("Decode error: \(decodeError)")
            if let decodingError = decodeError as? DecodingError {
                print("Decoding error details: \(decodingError)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Failed to decode JSON: \(jsonString)")
            }
            throw APIError.decodingError(decodeError)
        }
    }
    
    /// Update an existing trip
    func updateTrip(id: String, trip: Trip) async throws -> Trip {
        guard let url = APIConfiguration.Endpoint.trip(id: id).url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(trip)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response)
        
        do {
            let decoder = JSONDecoder()
            let updatedTrip = try decoder.decode(Trip.self, from: data)
            return updatedTrip
        } catch let error {
            if let decodingError = error as? DecodingError {
                print("Decoding error details: \(decodingError)")
            }
            throw APIError.decodingError(error)
        }
    }
    
    /// Delete a trip
    func deleteTrip(id: String) async throws {
        guard let url = APIConfiguration.Endpoint.trip(id: id).url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        try validateResponse(response)
    }
    
    // MARK: - Users API
    
    /// Fetch all users
    func fetchUsers() async throws -> [User] {
        guard let url = APIConfiguration.Endpoint.users.url else {
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
    
    /// Fetch a single user by ID
    func fetchUser(id: String) async throws -> User {
        guard let url = APIConfiguration.Endpoint.user(id: id).url else {
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
    
    /// Create a new user
    func createUser(_ user: User) async throws -> User {
        guard let url = APIConfiguration.Endpoint.users.url else {
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
    
    /// Update an existing user (full update)
    func updateUser(id: String, user: User) async throws -> User {
        guard let url = APIConfiguration.Endpoint.user(id: id).url else {
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
    
    /// Partially update a user
    func patchUser(id: String, updates: [String: Any]) async throws -> User {
        guard let url = APIConfiguration.Endpoint.user(id: id).url else {
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
    
    /// Delete a user
    func deleteUser(id: String) async throws {
        guard let url = APIConfiguration.Endpoint.user(id: id).url else {
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

