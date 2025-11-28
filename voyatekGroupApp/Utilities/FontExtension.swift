//
//  FontExtension.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Satoshi Font Extension
extension Font {
    static func satoshi(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // Try to use Satoshi font, fallback to system font if not available
        // User needs to add Satoshi font files to the project
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Satoshi-Bold"
        case .medium, .semibold:
            fontName = "Satoshi-Medium"
        default:
            fontName = "Satoshi-Regular"
        }
        
        if let satoshiFont = UIFont(name: fontName, size: size) {
            return Font(satoshiFont)
        }
        // Fallback to system font
        return .system(size: size, weight: weight)
    }
    
    static func satoshiBold(size: CGFloat) -> Font {
        if let satoshiFont = UIFont(name: "Satoshi-Bold", size: size) {
            return Font(satoshiFont)
        }
        return .system(size: size, weight: .bold)
    }
    
    static func satoshiMedium(size: CGFloat) -> Font {
        if let satoshiFont = UIFont(name: "Satoshi-Medium", size: size) {
            return Font(satoshiFont)
        }
        return .system(size: size, weight: .medium)
    }
}

