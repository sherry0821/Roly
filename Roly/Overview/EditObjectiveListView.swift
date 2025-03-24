//
//  EditObjectiveListView.swift
//  Roly
//
//  Created by 劉采璇 on 3/17/25.
//

import SwiftUI

struct EditObjectiveListView: View {
    @State private var draggedObjective: String?
    @Binding var objectives: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                // Q1 Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Q1")
                        .font(.caption)
                    ForEach(0..<2) { index in
//                        if index < objectives.count {
                            EditObjectiveRow(objectives: $objectives, index: index)
                                .onDrag {
                                    self.draggedObjective = objectives[index]
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(
                                    destinationItem: objectives[index],
                                    objectives: $objectives,
                                    draggedItem: $draggedObjective))
//                        }
                    }
                }

                // Q2 Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Q2")
                        .font(.caption)
                    ForEach(2..<4) { index in
                        if index < objectives.count {
                            EditObjectiveRow(objectives: $objectives, index: index)
                                .onDrag {
                                    self.draggedObjective = objectives[index]
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(
                                    destinationItem: objectives[index],
                                    objectives: $objectives,
                                    draggedItem: $draggedObjective))
                        }
                    }
                }

                // Q3 Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Q3")
                        .font(.caption)
                    ForEach(4..<6) { index in
                        if index < objectives.count {
                            EditObjectiveRow(objectives: $objectives, index: index)
                                .onDrag {
                                    self.draggedObjective = objectives[index]
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(
                                    destinationItem: objectives[index],
                                    objectives: $objectives,
                                    draggedItem: $draggedObjective))
                        }
                    }
                }

                // Q4 Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Q4")
                        .font(.caption)
                    ForEach(6..<8) { index in
                        if index < objectives.count {
                            EditObjectiveRow(objectives: $objectives, index: index)
                                .onDrag {
                                    self.draggedObjective = objectives[index]
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.text], delegate: DropViewDelegate(
                                    destinationItem: objectives[index],
                                    objectives: $objectives,
                                    draggedItem: $draggedObjective))
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

struct EditObjectiveRow: View {
    @Binding var objectives: [String]
    @FocusState private var isTextFieldFocused: Bool
    
    let index: Int

    private var placeholder: String {
        let quarter = (index / 2) + 1
        let position = (index % 2) + 1
        return "Objective \(position) in Q\(quarter)"
    }
    
    private var shouldBeOpaque: Bool {
        isTextFieldFocused || !objectives[index].isEmpty
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "target")
            
            TextField(placeholder, text: Binding(
                get: { index < objectives.count ? objectives[index] : "" },
                set: { newValue in
                    if index < objectives.count {
                        objectives[index] = newValue
                    }
                }
            ))
            .lineLimit(1)
            .focused($isTextFieldFocused)
            
            Spacer()
            if objectives[index].isEmpty {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(isTextFieldFocused ? .rolyMainPink : .black)
                    .opacity(shouldBeOpaque ? 1.0 : 0.3)
                    .rotationEffect(.init(degrees: isTextFieldFocused ? 45 : 0))
                    .onTapGesture {
                        if isTextFieldFocused {
                            objectives[index] = ""
                        } else {
                            isTextFieldFocused = true
                        }
                    }
            } else {
                Image(systemName: "line.3.horizontal")
                    .opacity(0.4)
            }
        }
        .padding()
        // TODO: When user type the textfield to second row, expand to 100 height
        .frame(height: 50)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(shouldBeOpaque ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5))
        )
    }
}

#Preview {
    EditObjectiveListView(objectives: .constant(["Apple", "Banana", "Orange", "Strawberry", "Blueberry", "", "Pineapple", "Mango"]))
}
