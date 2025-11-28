//
//  UIKitTripBridge.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI
import UIKit

// MARK: - UIKit Bridge for Trip Detail View
struct UIKitTripBridge: UIViewControllerRepresentable {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> TripDetailViewController {
        let controller = TripDetailViewController(trip: trip)
        controller.onDismiss = {
            dismiss()
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: TripDetailViewController, context: Context) {
        // No updates needed
    }
}

