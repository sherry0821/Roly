//
//  ContentView.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

// Test push 2

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showIntro = true // Track if intro has been seen
    
    var body: some View {
        ZStack {
            // Base background to prevent white screen
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingView()
            } else if showIntro {
                IntroView(onComplete: {
                    print("DEBUG: Intro completed, switching to LoginView")
                    // Use a short delay to ensure proper view transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut) {
                            showIntro = false
                        }
                    }
                })
            } else if viewModel.userSession != nil {
                RolyView()
            } else {
                // Debug view to confirm we reach this point
                VStack {
                    Text("DEBUG: LoginView container ready")
                        .foregroundColor(.green)
                        .padding()
                    
                    // Explicitly wrap LoginView to ensure it's displayed
                    LoginViewWrapper()
                        .transition(.opacity)
                        .onAppear {
                            print("DEBUG: LoginViewWrapper appeared")
                        }
                }
            }
        }
        .onChange(of: viewModel.isLoading) { oldValue, newValue in
            print("DEBUG: isLoading changed to \(newValue)")
        }
        .onChange(of: showIntro) { oldValue, newValue in
            print("DEBUG: showIntro changed to \(newValue)")
        }
        .onChange(of: viewModel.userSession) { oldValue, newValue in
            print("DEBUG: userSession changed to \(newValue != nil ? "non-nil" : "nil")")
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Notice"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Separate wrapper to ensure proper initialization of LoginView
struct LoginViewWrapper: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            LoginView()
                .environmentObject(viewModel)
                .onAppear {
                    print("DEBUG: LoginView inside wrapper appeared")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1.5)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                
                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
            )
            .onAppear {
                isAnimating = true
            }
        }
    }
}
