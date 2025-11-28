//
//  LocationPickerView.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Location Picker View
struct LocationPickerView: View {
    @Binding var selectedLocation: String
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText = ""
    
    private var countries: [Country] {
        CountryProvider.shared.countries
    }
    
    private var filteredCountries: [Country] {
        guard !searchText.isEmpty else { return countries }
        return countries.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.dialCode.localizedCaseInsensitiveContains(searchText.replacingOccurrences(of: "+", with: ""))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Please select a city")
                            .font(.satoshi(size: 16))
                            .foregroundColor(.secondary)
                        
                        // Search Field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.blue)
                            TextField("Search city or airport", text: $searchText)
                                .font(.satoshi(size: 16))
                                .textInputAutocapitalization(.words)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        
                        // Results
                        VStack(spacing: 0) {
                            ForEach(filteredCountries) { country in
                                Button {
                                    selectedLocation = country.name
                                    dismiss()
                                } label: {
                                    LocationRow(country: country, width: geometry.size.width - 40)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                    }
                    .padding(20)
                }
                .background(Color(.white))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack(spacing: 12) {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.primary)
                            }
                            
                            Text("Where")
                                .font(.satoshiBold(size: 18))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Location Row
private struct LocationRow: View {
    let country: Country
    let width: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            Image("MapPinFill")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.satoshiBold(size: 16))
                    .foregroundColor(.primary)
                
                Text("\(country.dialCode)")
                    .font(.satoshi(size: 14))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(country.flag)
                    .font(.system(size: 20))
                Text(country.code)
                    .font(.satoshi(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: width, alignment: .leading)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LocationPickerView(selectedLocation: .constant(""))
}

