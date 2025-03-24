//
//  EditStrategyListView.swift
//  Roly
//
//  Created by 劉采璇 on 3/17/25.
//

import SwiftUI

struct EditStrategyListView: View {
    @State private var draggedStrategy: String?
    @Binding var strategies: [String]
    let maxStrategies = 5
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(strategies.enumerated()), id: \.offset) { index, _ in
                EditStrategyRow(strategies: $strategies, index: index)
                    .onChange(of: strategies[index]) { oldValue, newValue in
                        handleStrategyChange(index: index, oldValue: oldValue, newValue: newValue)
                    }
                    .onDrag {
                        self.draggedStrategy = strategies[index] // Set the dragged item
                        return NSItemProvider()
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(
                        destinationItem: strategies[index],
                        objectives: $strategies, // Use strategies binding
                        draggedItem: $draggedStrategy
                    ))
            }
            Spacer()
        }
        .padding()
        .containerRelativeFrame(.horizontal) { length, _ in
            length
        }
    }
    
    private func handleStrategyChange(index: Int, oldValue: String, newValue: String) {
        // Add new empty strategy row when the last row is filled
        if !newValue.isEmpty &&
            index == strategies.count - 1 &&
            strategies.count < maxStrategies {
            strategies.append("")
        }
        
        // If a strategy is emptied and it's not the last one, remove it (commented out as in original)
        if newValue.isEmpty &&
            index < strategies.count - 1 &&
            strategies.count > 1 {
            // strategies.remove(at: index)
        }
    }
}

struct EditStrategyRow: View {
    @Binding var strategies: [String]
    @FocusState private var isTextFieldFocused: Bool
    
    let index: Int
    
    private var shouldBeOpaque: Bool {
        isTextFieldFocused || !strategies[index].isEmpty
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "inset.filled.diamond")
                .opacity(shouldBeOpaque ? 1.0 : 0.3)
                .onTapGesture {
                    isTextFieldFocused = true
                }
            if index < strategies.count {
                TextField("Strategy \(index + 1)", text: $strategies[index])
                    .lineLimit(1)
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
            }
            Spacer()
            
            if strategies[index].isEmpty {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(isTextFieldFocused ? .rolyMainPink : .black)
                    .opacity(shouldBeOpaque ? 1.0 : 0.3)
                    .rotationEffect(.init(degrees: isTextFieldFocused ? 45 : 0))
                    .onTapGesture {
                        if isTextFieldFocused {
                            strategies[index] = ""
                        } else {
                            isTextFieldFocused = true
                        }
                    }
            }
            
            if !strategies[index].isEmpty {
                Image(systemName: "line.3.horizontal")
            }
        }
        .padding()
    }
}

#Preview {
    EditStrategyListView(strategies: .constant(["Test strategy 1", "Test strategy 2"]))
}
