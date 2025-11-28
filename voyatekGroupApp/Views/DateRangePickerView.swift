//
//  DateRangePickerView.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

struct DateRangePickerView: View {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss
    
    private let calendar = Calendar.current
    private let months: [Date]
    private let today = Calendar.current.startOfDay(for: Date())
    
    init(startDate: Binding<Date?>, endDate: Binding<Date?>) {
        _startDate = startDate
        _endDate = endDate
        let startOfMonth = Calendar.current.startOfMonth(for: Date())
        var generatedMonths: [Date] = []
        for offset in 0..<6 {
            if let month = Calendar.current.date(byAdding: .month, value: offset, to: startOfMonth) {
                generatedMonths.append(month)
            }
        }
        self.months = generatedMonths
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        ForEach(months, id: \.self) { month in
                            MonthView(
                                month: month,
                                startDate: $startDate,
                                endDate: $endDate,
                                today: today,
                                onSelect: handleSelection(date:)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                
                Divider()
                
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        DateSummaryField(
                            title: "Start Date",
                            date: startDate,
                            placeholder: "Select date"
                        )
                        
                        DateSummaryField(
                            title: "End Date",
                            date: endDate,
                            placeholder: "Select date"
                        )
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Choose Date")
                            .font(.satoshiBold(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(isSelectionValid ? Color.blue : AppColors.primaryBlue)
                            .cornerRadius(4)
                    }
                    .disabled(!isSelectionValid)
                }
                .padding(20)
                .background(Color(.systemBackground))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 12) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }

                        Text("Date")
                            .font(.satoshiBold(size: 18))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private var isSelectionValid: Bool {
        if let startDate, let endDate {
            return startDate <= endDate
        }
        return false
    }
    
    private func handleSelection(date: Date) {
        let normalized = calendar.startOfDay(for: date)
        if startDate == nil || (startDate != nil && endDate != nil) {
            startDate = normalized
            endDate = nil
        } else if let currentStart = startDate {
            if normalized < currentStart {
                endDate = currentStart
                startDate = normalized
            } else {
                endDate = normalized
            }
        }
    }
}

// MARK: - Month View
private struct MonthView: View {
    let month: Date
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    let today: Date
    let onSelect: (Date) -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(monthTitle)
                .font(.satoshiBold(size: 20))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.satoshi(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date {
                        DayCellView(
                            date: date,
                            isDisabled: date < today,
                            isStart: isSameDay(date, startDate),
                            isEnd: isSameDay(date, endDate),
                            isInRange: isInRange(date),
                            onSelect: { onSelect(date) }
                        )
                    } else {
                        Color.clear.frame(height: 40)
                    }
                }
            }
        }
    }
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: month)
    }
    
    private var weekdays: [String] {
        ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    }
    
    private func daysInMonth() -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let firstWeekday = calendar.dateComponents([.weekday], from: firstOfMonth).weekday else {
            return []
        }
        
        var days: [Date?] = []
        let leadingSpaces = ((firstWeekday + 5) % 7) // convert to Monday-first
        days.append(contentsOf: Array(repeating: nil, count: leadingSpaces))
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        // pad to complete weeks
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    private func isSameDay(_ lhs: Date?, _ rhs: Date?) -> Bool {
        guard let lhs, let rhs else { return false }
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }
    
    private func isInRange(_ date: Date) -> Bool {
        guard let startDate, let endDate else { return false }
        return date > startDate && date < endDate
    }
}

// MARK: - Day Cell View
private struct DayCellView: View {
    let date: Date
    let isDisabled: Bool
    let isStart: Bool
    let isEnd: Bool
    let isInRange: Bool
    let onSelect: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onSelect) {
            Text(dayString)
                .font(.satoshi(size: 16))
                .foregroundColor(textColor)
                .frame(width: 40, height: 40)
                .background(backgroundView)
        }
        .disabled(isDisabled)
    }
    
    private var dayString: String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
    
    private var textColor: Color {
        if isStart || isEnd {
            return .white
        } else if isDisabled {
            return Color(.systemGray3)
        } else {
            return .primary
        }
    }
    
    private var backgroundView: some View {
        Group {
            if isStart || isEnd {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isStart ? Color.purple.opacity(0.7) : Color.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
            } else if isInRange {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.15))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            }
        }
    }
}

// MARK: - Date Summary Field
private struct DateSummaryField: View {
    let title: String
    let date: Date?
    let placeholder: String
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.satoshi(size: 12))
                .foregroundColor(.secondary)
            HStack {
                Text(formattedDate)
                    .font(.satoshiBold(size: 16))
                    .foregroundColor(date == nil ? .secondary : .primary)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
    }
    
    private var formattedDate: String {
        if let date {
            return formatter.string(from: date)
        }
        return placeholder
    }
}

// MARK: - Calendar Helpers
private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

#Preview {
    DateRangePickerView(startDate: .constant(Date()), endDate: .constant(Calendar.current.date(byAdding: .day, value: 3, to: Date())))
}

