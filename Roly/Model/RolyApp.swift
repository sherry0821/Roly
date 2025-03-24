//
//  RolyApp.swift
//  Roly
//
//  Created by 劉采璇 on 3/2/25.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth

@main
struct RolyApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        print("Starting Firebase configuration...")
        FirebaseApp.configure()
        print("Firebase configuration completed successfully.")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, .init(identifier: "en_US"))
                .environmentObject(viewModel)
                .modelContainer(for: [RolyTask.self])
        }
    }
    
    // Will allow us to find where our simulator data is saved:
//    init() {
//        print(URL.applicationSupportDirectory.path(percentEncoded: false))
//    }
}
