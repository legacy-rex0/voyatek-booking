//
//  AppColors.swift
//  voyatekGroupApp
//
//  Created by AI Assistant on 28/11/2025.
//

import SwiftUI

// MARK: - Color Palette
enum AppColors {
    static let accentLabel = Color(hex: "#647995")
    static let planTripBackground = Color(hex: "#EDF7F9")
    static let dateFieldBackground = Color(hex: "#F9FAFB")
    static let primaryBlue = Color(hex: "#0D6EFD")
    static let primaryText = Color(hex: "#1D2433")
}

// MARK: - Hex Initializer
extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

