//
//  LocationPickerField.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Location Picker Field Component
struct LocationPickerField: View {
    @Binding var location: String
    let placeholder: String
    @State private var showLocationPicker = false
    
    var body: some View {
        Button(action: {
            showLocationPicker = true
        }) {
            HStack(spacing: 12) {
                Image("MapPinOutline")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Where to?")
                        .font(.satoshi(size: 12))
                        .foregroundColor(.secondary)
                    
                    Text(location.isEmpty ? placeholder : location)
                        .font(.satoshiBold(size: 18))
                        .foregroundColor(location.isEmpty ? .secondary : .primary)
                }
                
                Spacer()
                
//                Image(systemName: "chevron.right")
//                    .font(.system(size: 14, weight: .semibold))
//                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(AppColors.dateFieldBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4), lineWidth: 0.7)
            )
            
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerView(selectedLocation: $location)
        }
    }
}

#Preview {
    LocationPickerField(location: .constant(""), placeholder: "Select City")
        .padding()
}

