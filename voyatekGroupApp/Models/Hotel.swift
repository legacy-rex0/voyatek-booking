//
//  Hotel.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

struct Hotel: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let roomType: String
    let checkInDate: String
    let checkOutDate: String
    let imageUrl: String?
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case rating
        case reviewCount = "review_count"
        case roomType = "room_type"
        case checkInDate = "check_in_date"
        case checkOutDate = "check_out_date"
        case imageUrl = "image_url"
        case price
    }
}

