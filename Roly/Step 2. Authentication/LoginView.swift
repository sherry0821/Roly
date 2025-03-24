//
//  LoginView.swift
//  Roly
//
//  Created by 劉采璇 on 3/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var quote = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isExpanded = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var isEmailVerified = false
    @State private var isConsentChecked = false
    @State private var isEmailFieldDisabled = false
    
    // Password validation states
    @State private var hasLetter = false
    @State private var hasNumber = false
    @State private var hasMinLength = false
    
    var body: some View {
        // Remove the extra NavigationStack to prevent conflicts
        ZStack {
            // Add a background color to ensure something is visible
            Color(colorScheme == .dark ? .black : .white)
                .ignoresSafeArea()
            
            VStack {
                Text("LoginView Loaded") // Test label to confirm rendering
                    .foregroundColor(.red)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.rolyMainPink.opacity(0.5),
                                Color.rolyMainPink.opacity(0.2)
                            ]), startPoint: .top, endPoint: .bottom))
                        .overlay(
                            RoundedRectangle(cornerRadius: 34)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.rolyMainPink.opacity(0.7),
                                            Color.rolyMainPink.opacity(0.2)
                                        ]), startPoint: .top, endPoint: .bottom)
                                    )
                        )
                    
                    VStack {
                        HStack {
                            Text("Roly")
                                .fontWeight(.bold)
                                .opacity(0.4)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                            Spacer()
                            if isExpanded {
                                Text("Login")
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            isExpanded = false
                                        }
                                    }
                            } else {
                                Text("Register")
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                            isExpanded = true
                                        }
                                    }
                            }
                        }
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            // 行2
                            HStack {
                                if isExpanded {
                                    Text("Register")
                                        .foregroundColor(.rolyMainPink)
                                        .font(.system(size: 32, weight: .semibold, design: .default))
                                } else {
                                    Text("Login")
                                        .foregroundColor(.rolyMainPink)
                                        .font(.system(size: 32, weight: .semibold, design: .default))
                                }
                                Spacer()
                                NavigationLink(destination: Text("apple login")) {
                                    Image(systemName: "apple.logo")
                                        .font(.title)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                }
                            }
                            
                            // Email Field
                            InputView(
                                text: $email,
                                placeholder: "Email",
                                icon: "envelope",
                                isDisabled: isEmailFieldDisabled
                            ).autocapitalization(.none)
                            
                            // Fullname field (register only)
                            if isExpanded {
                                InputView(text: $fullname, placeholder: "Fullname", icon: "person")
                            }
                            
                            // Password Field
                            ZStack {
                                InputView(
                                    text: $password,
                                    placeholder: "Password",
                                    isSecureField: true,
                                    icon: "key",
                                    customIconModifier: IconModifier(scale: 0.65, rotationAngle: -45))
                                Text("Forgot")
                                    .font(.caption)
                                    .padding(.leading, 180)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            }
                            
                            // Confirm Password
                            if isExpanded {
                                ZStack {
                                    InputView(
                                        text: $confirmPassword,
                                        placeholder: "Confirm password",
                                        isSecureField: true,
                                        icon: "lock.trianglebadge.exclamationmark")
                                    if !password.isEmpty && confirmPassword == password {
                                        Image(systemName: "checkmark.circle.fill")
                                            .imageScale(.large)
                                            .fontWeight(.bold)
                                            .foregroundColor(.rolyMainPink)
                                            .padding(.leading, 210)
                                    } else if !confirmPassword.isEmpty {
                                        Image(systemName: "xmark")
                                            .imageScale(.large)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.red)
                                            .padding(.leading, 210)
                                    }
                                }
                            }
                        }
                        Spacer()
                        
                        HStack {
                            Text("I acknowledge my data will send to Roly team for analysis, research and marketing purposes.")
                                .font(.caption2)
                                .padding(.trailing, 17)
                                .foregroundColor(.rolyMainPink)
                            Button {
                                Task {
                                    do {
                                        if isExpanded {
                                            try await viewModel.createUser(
                                                withEmail: email,
                                                password: password,
                                                quote: quote,
                                                fullName: fullname)
                                        } else {
                                            try await viewModel.signIn(
                                                withEmail: email,
                                                password: password)
                                        }
                                    } catch {
                                        print("DEBUG: Error in LoginView: \(error)")
                                    }
                                }
                            } label: {
                                ZStack(alignment: .trailing) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 70, height: 16)
                                        .foregroundColor(formIsValid ? Color.rolyMainPink : (colorScheme == .dark ? .black : .white))
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(formIsValid ? Color.rolyMainPink : (colorScheme == .dark ? .black : .white))
                                        .overlay(
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(formIsValid ? Color.black : Color.gray)
                                        )
                                }
                            }
                            .disabled(!formIsValid)
                        }
                        .frame(width: 273)
                    }
                    .padding(30)
                }
                .frame(width: 333, height: isExpanded ? 547 : 415)
                
                Button {
                    // TODO:
                } label: {
                    VStack(alignment: .leading) {
                        Text("Newbie")
                            .font(.system(size: 32, weight: .medium, design: .default))
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                        Text("Discover our brand story")
                            .font(.footnote)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                    }
                    .padding(.trailing, 115)
                    .frame(width: 333, height: 116)
                }
                .background(Color.rolyMainPink)
                .cornerRadius(34)
                .padding(.top, 40)
            }
        }
        .onAppear {
            print("DEBUG: LoginView appeared fully")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notice"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage == "You can delete your account in the Profile section." {
                        // ContentView will handle navigation to RolyView
                    }
                }
            )
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && (!isExpanded || confirmPassword == password)
            && (!isExpanded || !fullname.isEmpty)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
