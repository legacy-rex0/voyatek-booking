//
//  HotelCard.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

struct HotelCard: View {
    let hotel: Hotel
    let onRemove: () -> Void
    @State private var currentImageIndex = 0
    
    // Mock images - in real app, this would come from hotel.imageUrls
    private let images = ["hotel1"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content with Padding
            VStack(alignment: .leading, spacing: 16) {
                // Hotel Image Slider
                ZStack(alignment: .bottom) {
                    // Image
                    Image(images[currentImageIndex])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                    
                    // Semi-transparent grey overlay at bottom with navigation buttons
                    VStack {
                        Spacer()
                        
                        HStack {
                            // Left navigation button
                            Button(action: {
                                withAnimation {
                                    currentImageIndex = (currentImageIndex - 1 + images.count) % images.count
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            // Right navigation button
                            Button(action: {
                                withAnimation {
                                    currentImageIndex = (currentImageIndex + 1) % images.count
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        )
                    }
                }
                .cornerRadius(12)
                .clipped()
                
                // Hotel Name
                Text(hotel.name)
                    .font(.satoshiBold(size: 20))
                    .foregroundColor(.primary)
                
                // Address
                Text(hotel.address)
                    .font(.satoshi(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Location and Rating
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Show in map")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text("\(hotel.rating, specifier: "%.1f") (\(hotel.reviewCount))")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text(hotel.roomType)
                            .font(.satoshi(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Check-in/Check-out
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("In: \(hotel.checkInDate)")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text("Out: \(hotel.checkOutDate)")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.primary)
                    }
                }
                
                // Horizontal Divider (Date Line)
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                // Action Links
                HStack(spacing: 20) {
                    LinkButton(title: "Hotel details")
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
                    Text(hotel.price)
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

#Preview {
    HotelCard(
        hotel: Hotel(
            id: "1",
            name: "Riviera Resort, Lekki",
            address: "18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1",
            rating: 8.5,
            reviewCount: 436,
            roomType: "King size room",
            checkInDate: "20-04-2024",
            checkOutDate: "29-04-2024",
            imageUrl: nil,
            price: "N123,450.00"
        ),
        onRemove: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

