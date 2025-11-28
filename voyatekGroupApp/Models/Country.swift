//
//  Country.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

struct Country: Codable, Identifiable, Hashable {
    var id: String { code }
    
    let name: String
    let flag: String
    let code: String
    let dialCode: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case flag
        case code
        case dialCode = "dial_code"
    }
}


