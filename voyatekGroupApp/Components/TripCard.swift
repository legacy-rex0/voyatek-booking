//
//  TripCard.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Trip Card Component
struct TripCard: View {
    let trip: Trip
    let onViewTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .topTrailing) {
                // Placeholder image - replace with actual image loading
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.4, green: 0.5, blue: 0.4), Color(red: 0.3, green: 0.4, blue: 0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .padding(.all, 10)
                    .overlay(
                        // Road illustration overlay
                        Image(systemName: "road.lanes")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.white.opacity(0.3))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                
                // Location Badge
                HStack(alignment: .center, spacing: 10) {
                    Text(trip.destination)
                        .font(.satoshi(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(8)
                .frame(height: 38)
                .frame(maxWidth: 100, alignment: .center)
                .background(.ultraThinMaterial)
                .cornerRadius(4)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            
            // Trip Details
            VStack(alignment: .leading, spacing: 8) {
                Text(trip.title ?? trip.destination)
                    .font(.satoshiBold(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                HStack {
                    Text(trip.formattedStartDate)
                    .font(.satoshi(size: 13))
                    .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    if let duration = trip.duration {
                        Text("\(duration) Days")
                            .font(.satoshi(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            
            // View Button - Navigation handled by parent NavigationLink
            HStack {
                Spacer()
                Text("View")
                    .font(.satoshiBold(size: 16))
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(4)
            .padding(16)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack {
        TripCard(
            trip: Trip(
                destination: "Paris",
                startDate: "2024-04-19T00:00:00Z",
                endDate: "2024-04-24T00:00:00Z",
                title: "Bahamas Family Trip"
            ),
            onViewTap: {}
        )
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}

