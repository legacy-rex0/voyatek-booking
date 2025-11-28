//
//  Trip.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

// MARK: - Trip Model
struct Trip: Codable, Identifiable, Hashable {
    let id: String?
    var destination: String
    var startDate: String
    var endDate: String
    var title: String?
    var travelStyle: String?
    var tripDescription: String?
    var imageUrl: String?
    var createdAt: String?
    var updatedAt: String?
    var flights: [Flight]?
    var hotels: [Hotel]?
    var activities: [Activity]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case title
        case travelStyle = "travel_style"
        case tripDescription = "trip_description"
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case flights
        case hotels
        case activities
    }
    
    // Computed property for duration
    var duration: Int? {
        guard let start = dateFromString(startDate),
              let end = dateFromString(endDate) else {
            return nil
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: start, to: end)
        return (components.day ?? 0) + 1 // Include both start and end days
    }
    
    // Computed property for formatted date
    var formattedStartDate: String {
        guard let date = dateFromString(startDate) else {
            return startDate
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "d'th' MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter.date(from: dateString)
    }
    
    // Initializer for creating new trips
    init(destination: String, startDate: String, endDate: String, title: String? = nil, travelStyle: String? = nil, tripDescription: String? = nil, imageUrl: String? = nil, flights: [Flight]? = nil, hotels: [Hotel]? = nil, activities: [Activity]? = nil) {
        self.id = nil
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.travelStyle = travelStyle
        self.tripDescription = tripDescription
        self.imageUrl = imageUrl
        self.createdAt = nil
        self.updatedAt = nil
        self.flights = flights
        self.hotels = hotels
        self.activities = activities
    }
    
    // Full initializer for API responses
    init(id: String?, destination: String, startDate: String, endDate: String, title: String?, travelStyle: String?, tripDescription: String?, imageUrl: String?, createdAt: String?, updatedAt: String?, flights: [Flight]? = nil, hotels: [Hotel]? = nil, activities: [Activity]? = nil) {
        self.id = id
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.travelStyle = travelStyle
        self.tripDescription = tripDescription
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.flights = flights
        self.hotels = hotels
        self.activities = activities
    }
}

