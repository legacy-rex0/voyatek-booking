//
//  Flight.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

struct Flight: Identifiable, Codable, Hashable {
    let id: String
    let airline: String
    let flightNumber: String
    let departureTime: String
    let departureDate: String
    let departureAirport: String
    let arrivalTime: String
    let arrivalDate: String
    let arrivalAirport: String
    let duration: String
    let isDirect: Bool
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case airline
        case flightNumber = "flight_number"
        case departureTime = "departure_time"
        case departureDate = "departure_date"
        case departureAirport = "departure_airport"
        case arrivalTime = "arrival_time"
        case arrivalDate = "arrival_date"
        case arrivalAirport = "arrival_airport"
        case duration
        case isDirect = "is_direct"
        case price
    }
}

