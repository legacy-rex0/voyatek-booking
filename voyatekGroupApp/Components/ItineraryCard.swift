//
//  ItineraryCard.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Itinerary Type
enum ItineraryType {
    case flights
    case hotels
    case activities
    
    var title: String {
        switch self {
        case .flights: return "Flights"
        case .hotels: return "Hotels"
        case .activities: return "Activities"
        }
    }
    
    var iconName: String {
        switch self {
        case .flights: return "AirplaneIcon"
        case .hotels: return "BuildingsIcon"
        case .activities: return "RoadHorizonIcon"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .flights: return Color(hex: "#0D6EFD")
        case .hotels: return Color(hex: "#E7F0FF")
        case .activities: return Color(hex: "#000031")
        }
    }
    
    var textColor: Color {
        switch self {
        case .flights: return .white
        case .hotels: return Color(hex: "#1D2433")
        case .activities: return .white
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .flights: return Color(hex: "#0D6EFD")
        case .hotels: return .white
        case .activities: return .white
        }
    }
    
    var buttonBgColor: Color {
        switch self {
        case .flights: return .white
        case .hotels: return Color(hex: "#0D6EFD")
        case .activities: return Color(hex: "#0D6EFD")
        }
    }
    
    var buttonText: String {
        switch self {
        case .flights: return "Add Flights"
        case .hotels: return "Add Hotels"
        case .activities: return "Add Activities"
        }
    }
    
    var parentBgColor: Color {
        switch self {
        case .flights: return Color(hex: "#F0F2F5")
        case .hotels: return Color(hex: "#344054")
        case .activities: return Color(hex: "#0054E4")
        }
    }
    
    var childBgColor: Color {
        return Color(hex: "#FFFFFF")
    }
    
    var illustration: some View {
        Group {
            switch self {
            case .flights:
                FlightIllustration()
            case .hotels:
                HotelIllustration()
            case .activities:
                ActivityIllustration()
            }
        }
    }
}

// MARK: - Itinerary Card Component
struct ItineraryCard: View {
    let type: ItineraryType
    let isEmpty: Bool
    let onAdd: () -> Void
    var flights: [Flight]? = nil
    var hotels: [Hotel]? = nil
    var activities: [Activity]? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            Text(type.title)
                .font(.satoshiBold(size: 24))
                .foregroundColor(type.textColor)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            // Description
            Text("Build, personalize, and optimize your itineraries with our trip planner.")
                .font(.satoshi(size: 14))
                .foregroundColor(type.textColor)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            Spacer()
            
            // Add Button (always shown)
            Button(action: onAdd) {
                Text(type.buttonText)
                    .font(.satoshiBold(size: 16))
                    .foregroundColor(type.buttonColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(type.buttonBgColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(minHeight: 200)
        .background(type.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    
    @ViewBuilder
    private var itemsContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch type {
            case .flights:
                if let flights = flights {
                    ForEach(flights) { flight in
                        FlightCard(flight: flight, onRemove: {})
                    }
                }
            case .hotels:
                if let hotels = hotels {
                    ForEach(hotels) { hotel in
                        HotelCard(hotel: hotel, onRemove: {})
                    }
                }
            case .activities:
                if let activities = activities {
                    ForEach(activities) { activity in
                        ActivityCard(activity: activity, onRemove: {})
                    }
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Flight Illustration
struct FlightIllustration: View {
    var body: some View {
        ZStack {
            // Light blue circle background
            Circle()
                .fill(Color(red: 0.85, green: 0.92, blue: 1.0))
                .frame(width: 200, height: 200)
            
            // Clouds
            HStack(spacing: 40) {
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 40, height: 30)
                
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 50, height: 35)
            }
            .offset(y: -20)
            
            // Airplane
            VStack {
                Spacer()
                AirplaneShape()
                    .fill(Color.blue)
                    .frame(width: 120, height: 80)
                    .offset(y: 20)
            }
        }
    }
}

// MARK: - Hotel Illustration
struct HotelIllustration: View {
    var body: some View {
        ZStack {
            // Light blue circle background
            Circle()
                .fill(Color(red: 0.85, green: 0.92, blue: 1.0))
                .frame(width: 200, height: 200)
            
            // Clouds
            HStack(spacing: 30) {
                CloudShape()
                    .fill(Color(red: 0.7, green: 0.85, blue: 1.0))
                    .frame(width: 35, height: 25)
                
                CloudShape()
                    .fill(Color(red: 0.7, green: 0.85, blue: 1.0))
                    .frame(width: 45, height: 30)
            }
            .offset(y: -30)
            
            // Hotel building
            VStack(spacing: 0) {
                Text("HOTEL")
                    .font(.satoshiBold(size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.purple)
                    .cornerRadius(4)
                    .offset(y: -10)
                
                HotelBuildingShape()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
            }
        }
    }
}

// MARK: - Activity Illustration
struct ActivityIllustration: View {
    var body: some View {
        ZStack {
            // Light blue circle background
            Circle()
                .fill(Color(red: 0.85, green: 0.92, blue: 1.0))
                .frame(width: 200, height: 200)
            
            // Clouds
            HStack(spacing: 35) {
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 40, height: 30)
                
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 45, height: 32)
            }
            .offset(y: -25)
            
            // Hot air balloon
            HotAirBalloonShape()
                .fill(Color.blue)
                .frame(width: 100, height: 120)
        }
    }
}

// MARK: - Custom Shapes
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.width * 0.1, y: rect.height * 0.3, width: rect.width * 0.3, height: rect.height * 0.4))
        path.addEllipse(in: CGRect(x: rect.width * 0.3, y: rect.height * 0.2, width: rect.width * 0.4, height: rect.height * 0.5))
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.height * 0.3, width: rect.width * 0.3, height: rect.height * 0.4))
        return path
    }
}

struct AirplaneShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Simplified airplane shape
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: rect.width * 0.9, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.7))
        path.closeSubpath()
        
        // Tail
        path.move(to: CGPoint(x: rect.width * 0.1, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.4))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.6))
        path.closeSubpath()
        
        return path
    }
}

struct HotelBuildingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Building base
        path.addRect(CGRect(x: rect.width * 0.2, y: rect.height * 0.3, width: rect.width * 0.6, height: rect.height * 0.7))
        
        // Windows
        let windowSize: CGFloat = rect.width * 0.1
        let spacing: CGFloat = rect.width * 0.05
        for row in 0..<3 {
            for col in 0..<3 {
                let x = rect.width * 0.25 + CGFloat(col) * (windowSize + spacing)
                let y = rect.height * 0.4 + CGFloat(row) * (windowSize + spacing)
                path.addRect(CGRect(x: x, y: y, width: windowSize, height: windowSize))
            }
        }
        
        return path
    }
}

struct HotAirBalloonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Balloon (ellipse)
        path.addEllipse(in: CGRect(x: rect.width * 0.1, y: 0, width: rect.width * 0.8, height: rect.height * 0.7))
        
        // Basket (rectangle)
        path.addRect(CGRect(x: rect.width * 0.35, y: rect.height * 0.7, width: rect.width * 0.3, height: rect.height * 0.3))
        
        // Ropes
        path.move(to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.35, y: rect.height * 0.7))
        
        path.move(to: CGPoint(x: rect.width * 0.8, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.65, y: rect.height * 0.7))
        
        return path
    }
}

#Preview {
    VStack(spacing: 20) {
        ItineraryCard(type: .flights, isEmpty: true, onAdd: {})
        ItineraryCard(type: .hotels, isEmpty: true, onAdd: {})
        ItineraryCard(type: .activities, isEmpty: true, onAdd: {})
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}

