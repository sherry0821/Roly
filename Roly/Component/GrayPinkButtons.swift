//
//  SaveDiscardButtons.swift
//  Roly
//
//  Created by 劉采璇 on 3/18/25.
//

import SwiftUI

struct GrayPinkButtons: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showingDeleteConfirmation: Bool
    @Binding var title: String?
    let onSave: () -> Void
    let onDiscard: () -> Void
    var showDiscardButton = true
    
    var useArrows: Bool = false // New parameter to toggle arrow icons
    var useEdit: Bool = false // New parameter to toggle edit mode (xmark + highlighter)

    private var progressValue: Double {
        // If title is nil or empty, half fill; otherwise full
        title?.isEmpty ?? false ? 0 : 1.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 40) {
                // Discard Button
                if showDiscardButton {
                    Button(action: {
                        if useArrows {
                            onDiscard() // Directly use the provided discard action (e.g., previous page)
                        } else if useEdit {
                            dismiss()
                        } else if showingDeleteConfirmation {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dismiss()
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showingDeleteConfirmation = true
                            }
                        }
                    }) {
                        Image(systemName: useArrows ? "arrow.left" : "xmark")
                            .foregroundColor(useArrows ? .black : (showingDeleteConfirmation ? .white : .black))
                            .frame(width: useArrows ? 100 : (showingDeleteConfirmation ? geometry.size.width - 140 : 100),
                                   height: 100)
                            .background(useArrows ? Color.black.opacity(0.1) : (showingDeleteConfirmation ? Color.black : Color.gray.opacity(0.2)))
                            .clipShape(RoundedRectangle(cornerRadius: 34))
                    }
                    .animation(.easeInOut(duration: 0.3), value: showingDeleteConfirmation)
                } else { Spacer() }
                
                // Save Button
                Button(action: {
                    if useArrows {
                        onSave() // Next page or final save
                    } else if useEdit {
                        onSave() // Trigger navigation to EditMissionListView
                    } else if showingDeleteConfirmation {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingDeleteConfirmation = false
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            onSave()
                            dismiss()
                        }
                    }
                }) {
                    ZStack {
                        // Diagonal gradient background
                        GeometryReader { geo in
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.rolyMainPink.opacity(0.5),
                                    
                                    showingDeleteConfirmation
                                    ? Color.rolyMainPink.opacity(0.2)
                                    : Color.rolyMainPink.opacity(0.2 * progressValue)
                                ]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                            .frame(width: geo.size.width, height: geo.size.height)
                            .animation(.easeInOut(duration: 0.3), value: progressValue)
                        }
                        
                        if useArrows {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        } else if useEdit {
                            Image(systemName: "highlighter")
                                .foregroundColor(.black)
                        } else {
                            // Checkmark/Highlighter symbols
                            ZStack {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .opacity(showingDeleteConfirmation ? 0 : 1)
                                
                                Image(systemName: "highlighter")
                                    .foregroundColor(.black)
                                    .opacity(showingDeleteConfirmation ? 1 : 0)
                            }
                        }
                    }
                    .frame(width: showingDeleteConfirmation ? 100 : geometry.size.width - 140,
                           height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 34))
                }
                .animation(.easeInOut(duration: 0.3), value: showingDeleteConfirmation)
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    struct SaveDiscardButtonsPreview: View {
        @State private var showingDeleteConfirmation = false
        @State private var title: String? = "" // Optional title for preview
        
        var body: some View {
            VStack {
                // With title tracking
                GrayPinkButtons(
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    title: $title,
                    onSave: {
                        print("Save action triggered with title")
                    },
                    onDiscard: {}
                )
                .padding()
                
                // Without title tracking
                GrayPinkButtons(
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    title: .constant(nil), // Pass nil explicitly
                    onSave: {
                        print("Save action triggered without title")
                    },
                    onDiscard: {}
                )
                .padding()
                
                // Edit mode
                GrayPinkButtons(
                    showingDeleteConfirmation: $showingDeleteConfirmation,
                    title: .constant(nil),
                    onSave: { print("Navigate to Edit") },
                    onDiscard: { print("Dismiss") },
                    useEdit: true
                )
                .padding()
            }
        }
    }
    
    return SaveDiscardButtonsPreview()
}
