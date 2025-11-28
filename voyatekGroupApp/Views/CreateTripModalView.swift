//
//  CreateTripModalView.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

struct TripFormData {
    var name: String
    var style: TravelStyle
    var description: String
}

enum TravelStyle: String, CaseIterable, Identifiable {
    case solo = "Solo"
    case couple = "Couple"
    case family = "Family"
    case group = "Group"
    
    var id: String { rawValue }
}

struct CreateTripModalView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var tripName: String = ""
    @State private var selectedStyle: TravelStyle = .solo
    @State private var tripDescription: String = ""
    @State private var showStyleMenu = false
    
    let onSubmit: (TripFormData) -> Void
    
    private var isFormValid: Bool {
        !tripName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    formFields
                }
                .padding(20)
            }
            .background(Color.white)
            // .toolbar {
            //     ToolbarItem(placement: .navigationBarTrailing) {
            //         Button(action: { dismiss() }) {
            //             Image(systemName: "xmark")
            //                 .foregroundColor(.primary)
            //         }
            //     }
            // }
        }
        .interactiveDismissDisabled()
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 56, height: 56)
                    Image("tripTreeIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Create a Trip")
                    .font(.satoshiBold(size: 14))
                Text("Let's Go! Build Your Next Adventure")
                    .font(.satoshi(size: 11))
                    .foregroundColor(AppColors.accentLabel)
            }
        }
        .padding()
        .background(
            Image("headerOverlay")
                .resizable()
                .scaledToFill()
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private var formFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Trip Name")
                    .font(.satoshi(size: 14))
                TextField("Enter the trip name", text: $tripName)
                    .textFieldStyle(ModalTextFieldStyle())
                    .font(.satoshi(size: 12))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Travel Style")
                    .font(.satoshi(size: 14))
                Menu {
                    ForEach(TravelStyle.allCases) { style in
                        Button(action: {
                            selectedStyle = style
                        }) {
                            HStack {
                                Text(style.rawValue)
                                    .font(.satoshi(size: 12))
                                if style == selectedStyle {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedStyle.rawValue)
                            .foregroundColor(.primary)
                            .font(.satoshi(size: 12))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Trip Description")
                    .font(.satoshi(size: 14))
                TextEditor(text: $tripDescription)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .font(.satoshi(size: 12))
                    .overlay(
                        Group {
                            if tripDescription.isEmpty {
                                Text("Tell us more about the trip")
                                    .font(.satoshi(size: 12))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 18)
                                    .allowsHitTesting(false)
                            }
                        }
                    )
            }
            
            Button(action: handleSubmit) {
                Text("Next")
                    .font(.satoshiBold(size: 16))
                    .foregroundColor(isFormValid ? .white : Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primaryBlue.opacity(isFormValid ? 1 : 0.4))
                    )
            }
            .disabled(!isFormValid)
            .padding(.top, 12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private func handleSubmit() {
        guard isFormValid else { return }
        onSubmit(TripFormData(name: tripName, style: selectedStyle, description: tripDescription))
        dismiss()
    }
}

// MARK: - Custom Text Field Style
struct ModalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding()
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

#Preview {
    CreateTripModalView { _ in }
}

