//
//  UIKitBridge.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI
import UIKit

// MARK: - UIKit Bridge for SwiftUI
struct UIKitBridge: UIViewControllerRepresentable {
    let user: User
    var onDismiss: (() -> Void)? = nil
    
    func makeUIViewController(context: Context) -> UserDetailViewController {
        let controller = UserDetailViewController(user: user)
        controller.onDismiss = onDismiss
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UserDetailViewController, context: Context) {
        // No updates needed
    }
}

