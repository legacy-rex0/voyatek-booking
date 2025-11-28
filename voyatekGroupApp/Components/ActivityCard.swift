//
//  ActivityCard.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    let onRemove: () -> Void
    @State private var currentImageIndex = 0
    
    // Mock images - in real app, this would come from activity.imageUrls
    private let images = ["activity1"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content with Padding
            VStack(alignment: .leading, spacing: 16) {
                // Activity Image Slider
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
                
                // Activity Name
                Text(activity.name)
                    .font(.satoshiBold(size: 20))
                    .foregroundColor(.primary)
                
                // Description
                Text(activity.description)
                    .font(.satoshi(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                // Location, Rating, Duration
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                        Text(activity.location)
                            .font(.satoshi(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text("\(activity.rating, specifier: "%.1f") (\(activity.reviewCount))")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text(activity.duration)
                            .font(.satoshi(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Scheduled Time
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {}) {
                        Text("Change time")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("\(activity.scheduledTime) on \(activity.scheduledDate)")
                            .font(.satoshi(size: 14))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("Day \(activity.dayNumber) (Activity \(activity.activityNumber))")
                            .font(.satoshi(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
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
                    Text(activity.price)
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
    ActivityCard(
        activity: Activity(
            id: "1",
            name: "The Museum of Modern Art",
            description: "Works from Van Gogh to Warhol & beyond plus a sculpture garden, 2 cafes & The modern restaurant.",
            location: "Melbourne, Australia",
            rating: 8.5,
            reviewCount: 436,
            duration: "1 hour",
            scheduledTime: "10:30 AM",
            scheduledDate: "Mar 19",
            dayNumber: 1,
            activityNumber: 1,
            imageUrl: nil,
            price: "₦ 123,450.00"
        ),
        onRemove: {}
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}

