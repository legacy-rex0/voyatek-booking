//
//  CountryProvider.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import Foundation

final class CountryProvider {
    static let shared = CountryProvider()
    
    private(set) var countries: [Country] = []
    
    private init() {
        loadCountries()
    }
    
    private func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("⚠️ countries.json not found in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            countries = try decoder.decode([Country].self, from: data)
        } catch {
            print("⚠️ Failed to decode countries.json: \(error.localizedDescription)")
            countries = []
        }
    }
}


