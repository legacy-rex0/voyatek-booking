//
//  FlightCard.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

struct FlightCard: View {
    let flight: Flight
    let onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content with Padding
            VStack(alignment: .leading, spacing: 16) {
                // Airline Info
                HStack {
                    // Airline Logo
                    Image("AmericanAirline")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(flight.airline)
                            .font(.satoshiBold(size: 16))
                        Text(flight.flightNumber)
                            .font(.satoshi(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Flight Schedule
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(flight.departureTime)
                            .font(.satoshiBold(size: 18))
                        Text(flight.departureDate)
                            .font(.satoshi(size: 12))
                            .foregroundColor(.secondary)
                        Text(flight.departureAirport)
                            .font(.satoshi(size: 14, weight: .medium))
                    }
                    
                    Spacer()
                    
                    // Flight path
                    VStack(spacing: 4) {
                        // Image(systemName: "airplane")
                        //     .font(.system(size: 16))
                        //     .foregroundColor(.blue)
                        HStack(spacing: 4) {
                            Image("AirplaneFlying")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(flight.duration)
                                .font(.satoshi(size: 12))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                            Image("AirplaneLanding")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 4)
                                
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width, height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        if flight.isDirect {
                            Text("Direct")
                                .font(.satoshi(size: 10))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(minWidth: 80)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(flight.arrivalTime)
                            .font(.satoshiBold(size: 18))
                        Text(flight.arrivalDate)
                            .font(.satoshi(size: 12))
                            .foregroundColor(.secondary)
                        Text(flight.arrivalAirport)
                            .font(.satoshi(size: 14, weight: .medium))
                    }
                }
                
                // Horizontal Divider (Date Line)
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                // Action Links
                HStack(spacing: 20) {
                    LinkButton(title: "Flight details")
                    LinkButton(title: "Price details")
                    LinkButton(title: "Edit details")
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            
            // Horizontal Divider (Details Line)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            // Price and Remove Button Section (Full Width, Outside Padding)
            VStack(spacing: 0) {
                // Price Section (White Background)
                HStack {
                    Text(flight.price)
                        .font(.satoshiBold(size: 18))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.white)
                
                // Remove Button Section (Light Reddish-Pink Background)
                Button(action: onRemove) {
                    HStack(spacing: 8) {
                        Text("Remove")
                            .font(.satoshi(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#B02A37"))
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#B02A37"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
                .background(Color(hex: "#FCE8E8"))
            }
        }
        .cornerRadius(4)
        .background(Color(.systemBackground))
    }
}

struct LinkButton: View {
    let title: String
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .font(.satoshi(size: 14))
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    FlightCard(
        flight: Flight(
            id: "1",
            airline: "American Airlines",
            flightNumber: "AA-829",
            departureTime: "08:35",
            departureDate: "Sun, 20 Aug",
            departureAirport: "LOS",
            arrivalTime: "09:55",
            arrivalDate: "Sun, 20 Aug",
            arrivalAirport: "SIN",
            duration: "1h 45m",
            isDirect: true,
            price: "N 123,450.00"
        ),
        onRemove: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

