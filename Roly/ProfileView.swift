//
//  ProfileView.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteAlert = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack(spacing: 40) {
                    HStack {
                        Text(user.initials)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .frame(width: 40, height: 40)
                            .background(Color.rolyMainPink/*.opacity(0.2)*/)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Welcome to Roly 2025,")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(Color.rolyMainPink)
                            Text(user.fullname)
                                .font(.headline)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                            Text(user.quote)
                                .font(.caption)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        }
                        Spacer()
                        NavigationLink(destination: EditProfileView(
                            fullname: user.fullname,
                            quote: user.quote,
                            onSave: {},
                            onCancel: {}
                        )) {
                            Image(systemName: "highlighter")
                                .tint(.rolyMainPink)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        Button {
                            // TODO:
                        } label: {
                            SettingsRowView(
                                imageName: "gear",
                                title: "Version",
                                tintColor: Color(.systemGray)
                            )
                        }
                        
                        Button {
                            // TODO:
                        } label: {
                            SettingsRowView(
                                imageName: "lock",
                                title: "Change Password",
                                tintColor: Color(.systemGray)
                            )
                        }
                        
                        Button {
                            // TODO:
                        } label: {
                            SettingsRowView(
                                imageName: "mail",
                                title: "Change Email",
                                tintColor: Color(.systemGray)
                            )
                        }
                    }
                    Spacer()
                                        
                    HStack {
                        Button {
                            showDeleteAlert = true // Show confirmation alert
                        } label: {
                            Text("Delete Account")
                                .foregroundColor(.white)
                                .frame(width: 160, height: 160) // 100x100 size
                                .background(Color.rolyMainPink)
                                .clipShape(RoundedRectangle(cornerRadius: 34))
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Account"),
                                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                                primaryButton: .destructive(Text("Delete")) {
                                    Task {
                                        do {
                                            try await viewModel.deleteAccount()
                                        } catch {
                                            print("Failed to delete account: \(error.localizedDescription)")
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        Spacer()
                        
                        Button {
                            viewModel.signOut()
                        } label: {
                            Text("Log Out")
                                .foregroundColor(.white)
                                .frame(width: 160, height: 160) // Consistent size
                                .background(Color.rolyMainPink)
                                .clipShape(RoundedRectangle(cornerRadius: 34))
                        }
                    }
//                    .padding(.bottom, 10)
                }
                .padding(.horizontal, 30)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject({
            let vm = AuthViewModel()
            vm.currentUser = User(
                id: "testID",
                fullname: "Test User",
                quote: "Test Quote",
                email: "test@example.com",
                topPriority: nil,    // Optional, added for completeness
                mission: nil,        // Optional, added for completeness
                strategies: [],       // Required, added to fix error
                objectives: []
            )
            return vm
        }()) // 使用閉包初始化並注入 viewModel
}
