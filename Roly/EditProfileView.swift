//
//  EditProfileView.swift
//  Roly
//
//  Created by 劉采璇 on 3/15/25.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var tempFullname: String
    @State private var tempQuote: String
    let fullname: String
    let quote: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    init(fullname: String, quote: String, onSave: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.fullname = fullname
        self.quote = quote
        self._tempFullname = State(initialValue: fullname)
        self._tempQuote = State(initialValue: quote)
        self.onSave = onSave
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Name")
                    TextField("Fullname", text: $tempFullname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Quote")
                    TextField("Quote", text: $tempQuote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 25)
            
            Spacer()
            
            HStack {
                Button {
                    dismiss()
                    onCancel()
                } label: {
                    Text("Cancel")
                        .tint(.black)
                        .frame(width: 160, height: 40)
                        .background(.white)
                        .cornerRadius(34)
                }
                Spacer()
                Button {
                    if let user = viewModel.currentUser {
                        let updatedUser = User(
                            id: user.id,
                            fullname: tempFullname,
                            quote: tempQuote,
                            email: user.email,
                            topPriority: user.topPriority,  // Preserve existing value
                            mission: user.mission,          // Preserve existing value
                            strategies: user.strategies,     // Preserve existing strategies
                            objectives: user.objectives
                        )
                        viewModel.currentUser = updatedUser
                    }
                    dismiss()
                    onSave()
                } label: {
                    Text("Save")
                        .tint(.white)
                        .frame(width: 160, height: 40)
                        .background(.rolyMainPink)
                        .cornerRadius(34)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    EditProfileView(fullname: "Test User", quote: "Test Quote", onSave: {}, onCancel: {})
        .environmentObject(AuthViewModel())
}
