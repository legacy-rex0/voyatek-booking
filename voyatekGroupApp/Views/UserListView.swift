//
//  UserListView.swift
//  voyatekGroupApp
//
//  Created by Micheal B. on 27/11/2025.
//

import SwiftUI

// MARK: - User List View (SwiftUI)
struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    @State private var showingCreateUser = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    LoadingView(message: "Loading users...")
                } else if let error = viewModel.error {
                     ErrorView(message: error.localizedDescription) {
                        await viewModel.fetchUsers()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.users) { user in
                                UserCard(user: user) {
                                    viewModel.selectedUser = user
                                    viewModel.showingUserDetail = true
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.refreshUsers()
                    }
                }
            }
            .navigationTitle("Users")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateUser = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showingCreateUser) {
                UserFormView(user: nil) { newUser in
                    Task {
                        await viewModel.createUser(newUser)
                    }
                }
            }
            .sheet(item: $viewModel.selectedUser) { user in
                // Using UIKit programmatic view controller
                NavigationView {
                    UIKitBridge(user: user, onDismiss: {
                        Task {
                            await viewModel.refreshUsers()
                        }
                    })
                }
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
}

// MARK: - User List View Model
@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedUser: User?
    @Published var showingUserDetail = false
    
    private let apiService = APIService.shared
    
    func fetchUsers() async {
        isLoading = true
        error = nil
        
        do {
            users = try await apiService.fetchUsers()
        } catch {
            self.error = error
            print("Error fetching users: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshUsers() async {
        do {
            users = try await apiService.fetchUsers()
        } catch {
            self.error = error
            print("Error refreshing users: \(error)")
        }
    }
    
    func createUser(_ user: User) async {
        do {
            let createdUser = try await apiService.createUser(user)
            users.insert(createdUser, at: 0)
            error = nil
        } catch {
            self.error = error
            print("Error creating user: \(error)")
        }
    }
    
    func updateUser(id: String, user: User) async {
        do {
            let updatedUser = try await apiService.updateUser(id: id, user: user)
            if let index = users.firstIndex(where: { $0.id == id }) {
                users[index] = updatedUser
            }
            error = nil
        } catch {
            self.error = error
            print("Error updating user: \(error)")
        }
    }
    
    func deleteUser(id: String) async {
        do {
            try await apiService.deleteUser(id: id)
            users.removeAll { $0.id == id }
            error = nil
        } catch {
            self.error = error
            print("Error deleting user: \(error)")
        }
    }
}

// MARK: - User Form View (SwiftUI)
struct UserFormView: View {
    let user: User?
    let onSave: (User) -> Void
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var email: String
    @State private var phone: String
    @State private var address: String
    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(user: User?, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        _name = State(initialValue: user?.name ?? "")
        _email = State(initialValue: user?.email ?? "")
        _phone = State(initialValue: user?.phone ?? "")
        _address = State(initialValue: user?.address ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    CustomTextField(
                        title: "Name",
                        text: $name,
                        placeholder: "Enter name"
                    )
                    
                    CustomTextField(
                        title: "Email",
                        text: $email,
                        placeholder: "Enter email",
                        keyboardType: .emailAddress
                    )
                }
                
                Section(header: Text("Contact Information")) {
                    CustomTextField(
                        title: "Phone",
                        text: $phone,
                        placeholder: "Enter phone number",
                        keyboardType: .phonePad
                    )
                    
                    CustomTextField(
                        title: "Address",
                        text: $address,
                        placeholder: "Enter address"
                    )
                }
            }
            .navigationTitle(user == nil ? "New User" : "Edit User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveUser()
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@")
    }
    
    private func saveUser() {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return
        }
        
        isSaving = true
        
        let updatedUser = User(
            name: name.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            phone: phone.isEmpty ? nil : phone.trimmingCharacters(in: .whitespaces),
            address: address.isEmpty ? nil : address.trimmingCharacters(in: .whitespaces)
        )
        
        onSave(updatedUser)
        dismiss()
    }
}

#Preview {
    UserListView()
}

