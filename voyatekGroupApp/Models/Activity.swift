//
//  Activity.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

struct Activity: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let location: String
    let rating: Double
    let reviewCount: Int
    let duration: String
    let scheduledTime: String
    let scheduledDate: String
    let dayNumber: Int
    let activityNumber: Int
    let imageUrl: String?
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case location
        case rating
        case reviewCount = "review_count"
        case duration
        case scheduledTime = "scheduled_time"
        case scheduledDate = "scheduled_date"
        case dayNumber = "day_number"
        case activityNumber = "activity_number"
        case imageUrl = "image_url"
        case price
    }
}

