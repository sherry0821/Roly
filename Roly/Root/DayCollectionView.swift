//
//  DayCollectionView.swift
//  Roly
//
//  Created by 劉采璇 on 3/4/25.
//

import SwiftUI
import SwiftData

struct DayCollectionView: View {
    let date: Date
    @Binding var sheetIsPresented: Bool
    @Binding var selectedDate: Binding<Date>
    @Binding var selectedPosition: Binding<Int>
    
    @Query /*private */var tasks: [RolyTask]
    @Environment(\.modelContext) var modelContext
    
    init(
        date: Date,
        sheetIsPresented: Binding<Bool>,
        selectedDate: Binding<Binding<Date>>,
        selectedPosition: Binding<Binding<Int>>
    ) {
        self.date = date
        self._sheetIsPresented = sheetIsPresented
        self._selectedDate = selectedDate
        self._selectedPosition = selectedPosition
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        self._tasks = Query(
            filter: #Predicate<RolyTask> { task in
                task.dueDate >= startOfDay && task.dueDate < endOfDay
            },
            sort: \RolyTask.position
        )
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Weekday text
            Text(weekdayForDate(date))
                .font(.body)
                .foregroundColor(Color.rolyMainPink)
            
            // For position 1: Task card or plus button
            if let task = tasks.first(where: { $0.position == 1 }) {
                NavigationLink(
                    destination: {
                        EditTaskView(task: task)  // 使用找到的 position 1 的 task
                            .environment(\.modelContext, modelContext)
                    },
                    label: {
                        TaskCardView(task: task)
                            .environment(\.modelContext, modelContext)
                    }
                )
            } else {
                PlusButtonView(position: 1) {
                    selectedDate.wrappedValue = date
                    selectedPosition.wrappedValue = 1
                    sheetIsPresented = true
                }
            }
            
            // For position 2: Task card or plus button
            if let task = tasks.first(where: { $0.position == 2 }) {
                NavigationLink(
                    destination: {
                        EditTaskView(task: task)  // Use the found task at position 2
                            .environment(\.modelContext, modelContext)
                    },
                    label: {
                        TaskCardView(task: task)
                            .environment(\.modelContext, modelContext)
                    }
                )
            } else {
                PlusButtonView(position: 2) {
                    selectedDate.wrappedValue = date
                    selectedPosition.wrappedValue = 2
                    sheetIsPresented = true
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    // Get weekday name for date
    private func weekdayForDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Full weekday name
        return formatter.string(from: date)
    }
}

struct PlusButtonView: View {
    let position: Int
    let onTapped: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: onTapped) {
            RoundedRectangle(cornerRadius: 34)
                .frame(width: 100, height: 100)
                .foregroundStyle(.rolyMainPink)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                )
        }
    }
}

#Preview {
    DayCollectionView(
        date: Date(),
        sheetIsPresented: .constant(false),
        selectedDate: .constant(.constant(Date())),
        selectedPosition: .constant(.constant(1))
    )
    .modelContainer(for: RolyTask.self, inMemory: true)
}
