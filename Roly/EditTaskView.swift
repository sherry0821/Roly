//
//  EditTaskView.swift
//  Roly
//
//  Created by 劉采璇 on 3/2/25.
//

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State /*private */var task: RolyTask
    
    @State private var title = ""
    @State private var note = ""
    @State private var dueDate: Date
    @State private var selectedPosition: Int
    @State private var notificationEnabled: Bool
    @State private var notificationTime: Date
    @State private var showingDeleteConfirmation = false
    
    init(task: RolyTask) {
        self._task = State(initialValue: task)
        self._title = State(initialValue: task.title)
        self._note = State(initialValue: task.note)
        self._dueDate = State(initialValue: task.dueDate)
        self._selectedPosition = State(initialValue: task.position)
        self._notificationEnabled = State(initialValue: task.notificationEnabled)
        self._notificationTime = State(initialValue: task.notificationTime)
    }
    
    var body: some View {
        NavigationStack {
            // Header
            ZStack {
                HStack(spacing: 20) {
                    Text("New Top Priority")
                    Image(systemName: "chevron.down")
                        .font(.caption)
                    Spacer()
                    PositionButtonView(
                        selectedPosition: $selectedPosition,
                        isDisabled: showingDeleteConfirmation
                    )
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            FormContentView(
                title: $title,
                note: $note,
                selectedPosition: $selectedPosition,
                notificationEnabled: $notificationEnabled,
                notificationTime: $notificationTime,
                dueDate: $dueDate,
                isDisabled: showingDeleteConfirmation
            )
            
            Spacer()
            
            GrayPinkButtons(
                showingDeleteConfirmation: $showingDeleteConfirmation,
                title: Binding(
                    get: { title }, // Wrap the String in an optional
                    set: { newValue in title = newValue ?? "" } // Unwrap with default empty string
                ),
                onSave: {
                    // Original saving function from CancelAndSaveView
                    task.title = title
                    task.note = note
                    task.dueDate = dueDate
                    task.position = selectedPosition
                    task.notificationEnabled = notificationEnabled
                    task.notificationTime = notificationTime
                    
                    modelContext.insert(task)
                    guard let _ = try? modelContext.save() else {
                        print("😡 Error: Save on EditTaskView did not work!")
                        return
                    }
                },
                onDiscard: {}
            )
            .padding(.horizontal, 30)
        }
        .onAppear() {
            // From task object to local vars
            title = task.title
            note = task.note
            dueDate = task.dueDate
            selectedPosition = task.position
            notificationEnabled = task.notificationEnabled
        }
        .navigationBarBackButtonHidden()
    }
}

struct FormContentView: View {
    @State private var showingDeleteConfirmation = false

    @Binding var title: String
    @Binding var note: String
    @Binding var selectedPosition: Int
    @Binding var notificationEnabled: Bool
    @Binding var notificationTime: Date
    @Binding var dueDate: Date
    @FocusState private var isTextFieldFocused: Bool
    
    let isDisabled: Bool
    
    // Define character and line limits
    private let maxCharacters = 50
    
    var body: some View {
        VStack(spacing: 10) {
            AddMSOView()
            HStack {
                TextField("Task title", text: $title, axis: .vertical)
                    .font(.title2)
                    .fontWeight(.bold)
                    .focused($isTextFieldFocused)
                    .frame(height: 100)
                    .onChange(of: title) { oldValue, newValue in
                        if newValue.count > self.maxCharacters {
                            self.title = String(oldValue.prefix(self.maxCharacters))
                        }
                    }
                    .disabled(isDisabled)
                Text("\(/*title.count) / \(*/maxCharacters - title.count)")
                    .font(.caption)
            }
            .padding(.horizontal, 30)
            
//            Toggle("Notification", isOn: $notificationEnabled)
//                .frame(height: 50)
//                .tint(.pink)
//                .disabled(isDisabled)

            HStack(spacing: 10) {
                SelectedDateTitleView(
                    dueDate: $dueDate,
                    isDisabled: showingDeleteConfirmation
                )
                Spacer()
                
                Image(systemName: notificationEnabled ? "bell.badge" : "bell.slash")
                    .font(.headline)
                    .onTapGesture {
                        notificationEnabled.toggle() // 切換狀態
                    }
                    .foregroundColor(notificationEnabled ? .rolyMainPink : .black) // 提供視覺提示
                    .disabled(isDisabled) // 禁用狀態
                    .frame(height: 50)
                    .opacity(isDisabled ? 0.5 : 1)
                
                DatePicker("", selection: $notificationTime, displayedComponents: [.hourAndMinute])
                    // TODO: 改顏色
                    .frame(width: 100, height: 50)
                    .disabled(!notificationEnabled || isDisabled)
            }
            .padding(.horizontal, 30)
            
            HStack{
                Text("15 \nmin")
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black))
                Spacer()
                Text("30 \nmin")
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black))
                Spacer()
                Text("45 \nmin")
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black))
                Spacer()
                Text("60 \nmin")
                    .multilineTextAlignment(.center)
                    .frame(width: 70, height: 70)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black))
            }
            .padding(.horizontal, 30)
            
            // Note
            HStack(spacing: 5) {
                TextField("Add note", text: $note, axis: .vertical)
                    .frame(height: 100)
                    .onChange(of: note) { oldValue, newValue in
                        if newValue.count > self.maxCharacters {
                            self.note = String(oldValue.prefix(self.maxCharacters))
                        }
                    }
                    .disabled(isDisabled)
                Spacer()
                Text("\(/*note.count) / \(*/maxCharacters - note.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 30)
        }
    }
}

// Helper function with @MainActor
@MainActor
private func createPreviewSetup() -> (ModelContainer, RolyTask) {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RolyTask.self, configurations: config)
    let previewTask = RolyTask(
        title: "",
        note: "",
        dueDate: Date(),
        position: 1
    )
    container.mainContext.insert(previewTask)
    return (container, previewTask)
}

#Preview {
    let (container, previewTask) = createPreviewSetup()
    EditTaskView(task: previewTask)
        .modelContainer(container)
}

struct AddMSOView: View {
    @State private var isShowMission: Bool = false
    @State private var isShowStrategy: Bool = false
    @State private var isShowObjective: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // Background Rectangles
                HStack(spacing: 0) {
                    // Mission (Gray) Rectangle
                    Rectangle()
                        .opacity(isShowMission && !isShowStrategy && !isShowObjective ? 1.0 : (isShowStrategy || isShowObjective ? 0.1 : 1.0))
                        .frame(width: isShowStrategy || isShowObjective ? 50 : nil, height: isShowMission ? 150 : 50)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            if isShowMission {
                                // Reset to initial state when clicking gray while expanded
                                isShowStrategy = false
                                isShowObjective = false
                            } else {
                                isShowMission = true
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: isShowMission ? 0 : 10))
                        .padding(.horizontal, isShowMission ? 0 : 30)
                    
                    if isShowMission {
                        // Strategy (Red) Rectangle
                        Rectangle()
                            .opacity(isShowStrategy ? 1.0 : 0.5)
                            .frame(width: isShowStrategy ? nil : 50, height: isShowMission ? 150 : 50)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isShowStrategy = true
                                isShowObjective = false
                            }
                        
                        // Objective (Blue) Rectangle
                        Rectangle()
                            .opacity(isShowObjective ? 1.0 : (isShowMission || !isShowStrategy ? 0.1 : 0.5))
                            .frame(width: isShowObjective ? nil : 50, height: isShowMission ? 150 : 50)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                isShowObjective = true
                                isShowStrategy = false
                            }
                    }
                }
                
                // Overlay Contents
                if !isShowMission {
                    HStack(spacing: 20) {
                        Image(systemName: "flag.fill")
                            .rotationEffect(Angle(degrees: -45))
                        Image(systemName: "inset.filled.diamond")
                        Image(systemName: "target")
                    }
                    .foregroundColor(.white)
                    .font(.caption)
//                    .opacity(0.7)
                } else if isShowMission && !isShowStrategy && !isShowObjective {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "flag.fill")
                                    .rotationEffect(Angle(degrees: -45))
                                    .font(.caption)
                                Text("Mission 1")
                                Spacer()
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "flag.fill")
                                    .rotationEffect(Angle(degrees: -45))
                                    .font(.caption)
                                Text("Mission 2")
                                Spacer()
                            }
                        }
                        .padding(.leading)
                        Image(systemName: "inset.filled.diamond")
                            .frame(width: 50)
                        Image(systemName: "target")
                            .frame(width: 50)
                    }
                } else if isShowStrategy {
                    HStack(spacing: 0) {
                        Image(systemName: "flag.fill")
                            .rotationEffect(Angle(degrees: -45))
                            .frame(width: 50)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "inset.filled.diamond")
                                    .font(.caption)
                                Text("Strategy 1")
                                Spacer()
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "inset.filled.diamond")
                                    .font(.caption)
                                Text("Strategy 2")
                                Spacer()
                            }
                        }
                        .padding(.leading)
                        Image(systemName: "target")
                            .frame(width: 50)
                    }
                } else if isShowObjective {
                    HStack(spacing: 0) {
                        Image(systemName: "flag.fill")
                            .rotationEffect(Angle(degrees: -45))
                            .frame(width: 50)
                        Image(systemName: "inset.filled.diamond")
                            .frame(width: 50)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "target")
                                    .font(.caption)
                                Text("Objective 1")
                                Spacer()
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "target")
                                    .font(.caption)
                                Text("Objective 2")
                                Spacer()
                            }
                        }
                        .padding(.leading)
                    }
                }
            }
            
            if isShowMission {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    Image(systemName: "xmark")
                }
                .onTapGesture {
                    isShowMission = false
                    isShowStrategy = false
                    isShowObjective = false
                }
            }
        }
    }
}
