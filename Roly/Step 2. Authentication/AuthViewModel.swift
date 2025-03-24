//
//  AuthViewModel.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isFirstLogin = false
    @Published var userSession: FirebaseAuth.User?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    init() {
        print("DEBUG: AuthViewModel initialized with isLoading: \(isLoading), userSession: \(userSession != nil ? "non-nil" : "nil")")
        self.userSession = Auth.auth().currentUser
        self.currentUser = nil
        
        Task {
            await fetchUser()
            self.isLoading = false
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        isLoading = true
        print("DEBUG: isLoading set to true in signIn")
        defer {
            isLoading = false
            print("DEBUG: isLoading set to false in signIn")
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password) // 使用 Auth.auth().signIn 嘗試登入
            self.userSession = result.user                                                  // 更新 userSession 為登入結果的用戶
            await fetchUser()                                                               // 呼叫 fetchUser() 從 Firestore 獲取用戶資料
            
            if let userId = currentUser?.id {
                let db = Firestore.firestore()
                let doc = try await db.collection("users").document(userId).getDocument()
                self.isFirstLogin = !(doc.data()?["surveyResponses"] != nil)
            }
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.userNotFound.rawValue:
                print("DEBUG: User not found (code: \(error.code))")
                self.alertMessage = "You haven't registered yet!"
                self.showAlert = true
                throw AuthError.userNotFound
            case AuthErrorCode.wrongPassword.rawValue:
                print("DEBUG: Wrong password (code: \(error.code))")
                self.alertMessage = "Incorrect password. Please try again."
                self.showAlert = true
                throw AuthError.wrongPassword
            case AuthErrorCode.invalidCredential.rawValue:
                print("DEBUG: Invalid credential (code: \(error.code))")
                self.alertMessage = "You haven't registered yet!"
                self.showAlert = true
                throw AuthError.userNotFound
            default:
                print("DEBUG: Failed to sign in: \(error.localizedDescription) (code: \(error.code))")
                self.alertMessage = "Error: \(error.localizedDescription)"
                self.showAlert = true
                throw error
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, quote: String, fullName: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(
                id: result.user.uid,
                fullname: fullName,
                quote: quote,
                email: email,
                topPriority: nil,
                mission: nil,
                strategies: [],
                objectives: ["", "", "", "", "", "", "", ""]
            )
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            self.currentUser = user
            self.isFirstLogin = true
        } catch let error as NSError {
            if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                throw AuthError.emailAlreadyInUse // Custom error for already registered
            }
            print("Registration error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.isFirstLogin = false
        } catch {
            print("DEBUG: Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        do {
            // Delete user data from Firestore
            if let userId = currentUser?.id {
                try await Firestore.firestore().collection("users").document(userId).delete()
            }
            
            // Delete Firebase Auth user
            try await user.delete()
            
            // Reset local state
            self.userSession = nil
            self.currentUser = nil
            self.isFirstLogin = false
        } catch {
            print("DEBUG: Failed to delete account: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            var user = try snapshot.data(as: User.self)
            // Ensure objectives is exactly 8 elements
            if user.objectives.count != 8 {
                user.objectives = Array(repeating: "", count: 8)
            }
            self.currentUser = user
            print("DEBUG: Fetched user objectives: \(user.objectives)")
        } catch {
            print("DEBUG: Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    func updateUserMission() {
        guard var user = currentUser else { return }
        
        // Ensure objectives is always 8 elements before saving
        if user.objectives.count != 8 {
            user.objectives = Array(repeating: "", count: 8)
        }
        
        // Update Firestore with the new mission data
        let userRef = Firestore.firestore().collection("users").document(user.id)
        
        userRef.updateData([
            "topPriority": user.topPriority ?? "",
            "mission": user.mission ?? "",
            "strategies": user.strategies,
            "objectives": user.objectives
        ]) { error in
            if let error = error {
                print("Error updating user mission: \(error.localizedDescription)")
            } else {
                print("Successfully updated user mission")
            }
        }
        
        // Update local currentUser to reflect the enforced 8 elements
        self.currentUser = user
    }
}

// Custom errors for specific cases
enum AuthError: Error {
    case userNotFound
    case emailAlreadyInUse
    case noCurrentUser
    case wrongPassword
}
