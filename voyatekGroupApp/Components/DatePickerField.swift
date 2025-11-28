//
//  DatePickerField.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Date Field Display Component
struct DatePickerField: View {
    let label: String
    let placeholder: String
    let date: Date?
    let action: () -> Void
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image("calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .padding(.trailing, 4)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.satoshi(size: 12))
                        .foregroundColor(AppColors.accentLabel)
                    
                    Text(displayText)
                        .font(.satoshiBold(size: 16))
                        .foregroundColor(date == nil ? AppColors.accentLabel : .primary)
                }
                .padding(.vertical, 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(AppColors.dateFieldBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4), lineWidth: 0.7)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var displayText: String {
        guard let date else { return placeholder }
        return formatter.string(from: date)
    }
}

#Preview {
    HStack(spacing: 12) {
        DatePickerField(label: "Start Date", placeholder: "Select", date: Date(), action: {})
        DatePickerField(label: "End Date", placeholder: "Select", date: nil, action: {})
    }
    .padding()
}

