//
//  PlanTripView.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - Plan Trip View
private enum PlanTripSheet: Identifiable {
    case date
    case create
    
    var id: Int { hashValue }
}

struct PlanTripView: View {
    @StateObject private var viewModel = PlanTripViewModel()
    @State private var selectedLocation = ""
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var tripTitle = ""
    @State private var selectedTravelStyle: TravelStyle = .solo
    @State private var tripDetailsDescription = ""
    @State private var activeSheet: PlanTripSheet?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section (Fixed at top)
                headerSection
                
                // Scrollable Content
                ScrollView {
                    VStack(spacing: 0) {
                        // Plan Your Dream Trip Section
                        planTripSection
                        
                        // Your Trips Section
                        yourTripsSection
                    }
                }
                .background(Color.white)
            }
            .task {
                await viewModel.fetchTrips()
            }
            .sheet(item: $activeSheet) { sheet in
            switch sheet {
                case .date:
                    DateRangePickerView(
                        startDate: $startDate,
                        endDate: $endDate
                    )
                    .presentationDetents([.large])
                case .create:
                    CreateTripModalView { data in
                        tripTitle = data.name
                        selectedTravelStyle = data.style
                        tripDetailsDescription = data.description
                        createTrip()
                    }
                    .presentationDetents([.fraction(0.85)])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
//            Spacer()
            
            Text("Plan a Trip")
                .font(.satoshiBold(size: 18))
                .foregroundColor(.primary)
                .padding(.leading, 6)
            
            Spacer()
            
            HStack(spacing: -8) {
                Circle()
                    .fill(Color(red: 1.0, green: 0.4, blue: 0.6))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text("D")
                            .font(.satoshiBold(size: 14))
                            .foregroundColor(.white)
                    )
                
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Plan Trip Section
    private var planTripSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Background Illustration with Form Card
            ZStack(alignment: .top) {
                // Background Image (Absolute Position with Contain)
                GeometryReader { geometry in
                    Image("tripBg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 1.2)
                        .clipped()
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                }
//                .frame(height: 200)
                
                
                // Title and Description (On top of image)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Plan Your Dream Trip in Minutes")
                        .font(.satoshiBold(size: 18))
                        .foregroundColor(.primary)
                    
                    Text("Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapade.")
                        .font(.satoshiMedium(size: 14))
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                        .padding(.top, 10)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.top, 36)
                .zIndex(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // White Form Card (Below text, pushed down more)
                VStack(spacing: 8) {
                    LocationPickerField(
                        location: $selectedLocation,
                        placeholder: "Select City"
                    )
                    
                    HStack(spacing: 12) {
                        DatePickerField(
                            label: "Start Date",
                            placeholder: "Enter Date",
                            date: startDate,
                            action: {
                                activeSheet = .date
                            }
                        )
                        
                        DatePickerField(
                            label: "End Date",
                            placeholder: "Enter Date",
                            date: endDate,
                            action: {
                                activeSheet = .date
                            }
                        )
                    }
                    
                    Button(action: {
                        activeSheet = .create
                    }) {
                        Text("Create a Trip")
                            .font(.satoshiBold(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppColors.primaryBlue)
                            .cornerRadius(4)
                    }
                    .disabled(selectedLocation.isEmpty || startDate == nil || endDate == nil)
                    .opacity(selectedLocation.isEmpty || startDate == nil || endDate == nil ? 0.6 : 1.0)
                }
                .padding(20)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                .padding(.top, 190)
                .zIndex(2)
            }
            .frame(height: 380)
        }
        .padding(.bottom, 40)
        .background(AppColors.planTripBackground)
    }
    
    // MARK: - Your Trips Section
    private var yourTripsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Your Trips")
                    .font(.satoshi(size: 16, weight: Font.Weight.semibold))
                    .foregroundColor(.primary)
                
                Text("Your trip itineraries and planned trips are placed here")
                    .font(.satoshi(size: 12))
                    .foregroundColor(AppColors.accentLabel)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            // Planned Trips Dropdown
            HStack {
                Text("Planned Trips")
                    .font(.satoshi(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            // Trip Cards
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if viewModel.trips.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No trips yet")
                        .font(.satoshi(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.trips) { trip in
                    NavigationLink(destination: UIKitTripBridge(trip: trip)) {
                        TripCard(trip: trip) {
                            // Navigation handled by NavigationLink
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical, 60)
    }
    
    // MARK: - Helper Methods
    private func createTrip() {
        guard !selectedLocation.isEmpty,
              let start = startDate,
              let end = endDate,
              start <= end else {
            return
        }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let newTrip = Trip(
            destination: selectedLocation,
            startDate: formatter.string(from: start),
            endDate: formatter.string(from: end),
            title: tripTitle.isEmpty ? nil : tripTitle,
            travelStyle: selectedTravelStyle.rawValue,
            tripDescription: tripDetailsDescription.isEmpty ? nil : tripDetailsDescription
        )
        
        Task {
            await viewModel.createTrip(newTrip)
            // Reset form
            selectedLocation = ""
            startDate = nil
            endDate = nil
            tripTitle = ""
            tripDetailsDescription = ""
        }
    }
}

// MARK: - Plan Trip View Model
@MainActor
class PlanTripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiService = APIService.shared
    
    func fetchTrips() async {
        isLoading = true
        error = nil
        
        do {
            // Mock data with flights, hotels, and activities
            trips = [
                Trip(
                    destination: "New York, United States of America",
                    startDate: "2024-03-21T00:00:00Z",
                    endDate: "2024-04-21T00:00:00Z",
                    title: "Bahamas Family Trip",
                    travelStyle: "solo",
                    flights: [
                        Flight(
                            id: "flight1",
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
                        )
                    ],
                    hotels: [
                        Hotel(
                            id: "hotel1",
                            name: "Riviera Resort, Lekki",
                            address: "18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1",
                            rating: 8.5,
                            reviewCount: 436,
                            roomType: "King size room",
                            checkInDate: "20-04-2024",
                            checkOutDate: "29-04-2024",
                            imageUrl: nil,
                            price: "N123,450.00"
                        )
                    ],
                    activities: [
                        Activity(
                            id: "activity1",
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
                        )
                    ]
                )
            ]
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func createTrip(_ trip: Trip) async {
        do {
            // In production, use trips endpoint
            // For now, just add to local array
            var newTrip = trip
            // Simulate API response with ID
            trips.insert(newTrip, at: 0)
            error = nil
        } catch {
            self.error = error
        }
    }
}

#Preview {
    PlanTripView()
}

