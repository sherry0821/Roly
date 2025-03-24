//
//  EditTaskListViewOld.swift
//  Roly
//
//  Created by 劉采璇 on 3/18/25.
//

import SwiftUI
import SwiftData

struct EditTaskListView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var tasks: [RolyTask]
    @State private var centerDate = Date.now
    
    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.firstWeekday = 2 // 星期一作為每週第一天
        return cal
    }()
    
    // 生成全年每週的起始日期（星期一）
    private var allWeekStartDates: [Date] {
        let year = calendar.component(.year, from: Date.now)
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let firstMondayOffset = (calendar.component(.weekday, from: startOfYear) + 5) % 7
        let firstMonday = calendar.date(byAdding: .day, value: -firstMondayOffset, to: startOfYear)!
        
        var weekStarts: [Date] = []
        var currentMonday = firstMonday
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
        
        while currentMonday <= endOfYear {
            weekStarts.append(currentMonday)
            currentMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: currentMonday)!
        }
        return weekStarts
    }
    
    // 初始定位到包含今天的週
    private var initialWeekIndex: Int {
        let today = Date.now
        return allWeekStartDates.firstIndex(where: { weekStart in
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            return today >= weekStart && today <= weekEnd
        }) ?? 0
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { // 移除 GeometryReader，使用固定高度
                // 導航欄
                MonthButtonRow(dueDate: $centerDate)
                    .frame(height: 50)
                
                // 垂直滑動的每週視圖
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(allWeekStartDates.indices, id: \.self) { index in
                                WeekView(weekStart: allWeekStartDates[index])
                                    .frame(height: 490) // 7 * 70，固定每週高度
                                    .id(index)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.paging)
                    .frame(height: 490) // 限制 ScrollView 高度為 7 天
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            scrollProxy.scrollTo(initialWeekIndex, anchor: .top)
                        }
                    }
                    .onChange(of: centerDate) { _, newValue in
                        let newWeekIndex = allWeekStartDates.firstIndex(where: { weekStart in
                            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
                            return newValue >= weekStart && newValue <= weekEnd
                        }) ?? initialWeekIndex
                        withAnimation {
                            scrollProxy.scrollTo(newWeekIndex, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

// 每週視圖
struct WeekView: View {
    let weekStart: Date
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<7) { dayOffset in
                TaskStackRow(dueDate: calendar.date(byAdding: .day, value: dayOffset, to: weekStart)!)
            }
        }
    }
}

// 修改後的 MonthButtonRow，支援導航
struct MonthButtonRow: View {
    @Binding var dueDate: Date
    private let calendar = Calendar.current
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Text(monthAbbreviation(for: dueDate))
                    .fontWeight(.bold)
                    .padding(.trailing, 10)
                Text(String(format: "%02d", dueDate.day))
                Text(",")
                    .padding(.trailing, 10)
                Text(String(dueDate.year))
            }
            HStack {
                Button(action: {
                    dueDate = calendar.date(byAdding: .month, value: -1, to: dueDate)!
                }) {
                    HStack(spacing: 10) {
                        Text(previousMonthAbbreviation)
                        Image(systemName: "chevron.left")
                    }
                }
                Spacer()
                Button(action: {
                    dueDate = calendar.date(byAdding: .month, value: 1, to: dueDate)!
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "chevron.right")
                        Text(nextMonthAbbreviation)
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.horizontal, 30)
        .frame(height: 50)
    }
    
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
    
    private var previousMonthAbbreviation: String {
        let prevMonth = calendar.date(byAdding: .month, value: -1, to: dueDate)!
        return monthAbbreviation(for: prevMonth)
    }
    
    private var nextMonthAbbreviation: String {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: dueDate)!
        return monthAbbreviation(for: nextMonth)
    }
}

struct TaskStackRow: View {
    let dueDate: Date // Changed from @Binding to let since we don't need to modify it
    private let calendar = Calendar.current
    
    @State private var anyTaskOpaque: Bool = false // Tracks spacing conditionally
    
    var body: some View {
        ZStack {
            VStack {
                Divider()
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(String(format: "%02d", dayNumber))
                        .fontWeight(.bold)
                    Text(weekdayAbbreviation)
                        .font(.caption)
                }
                Spacer()
            }
            VStack(alignment: .leading, spacing: anyTaskOpaque ? 8 : 2) {
                TaskListRow(
                    position: 1,
                    date: dueDate,
                    isOpaque: $anyTaskOpaque
                )
                TaskListRow(
                    position: 2,
                    date: dueDate,
                    isOpaque: $anyTaskOpaque
                )
            }
            .padding(.leading, 45)
        }
        .frame(height: 70)
        .padding(.horizontal, 30)
    }
    
    private var dayNumber: Int {
        return calendar.component(.day, from: dueDate)
    }
    
    private var weekdayAbbreviation: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Get weekday abbreviation (MON, TUE, etc.)
        return formatter.string(from: dueDate).uppercased()
    }
}

struct TaskListRow: View {
    let position: Int
    let date: Date
    @Binding var isOpaque: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.modelContext) var modelContext
    
    // Adjust to use better filtering
    @Query private var tasks: [RolyTask]
    @State private var taskTitle: String = ""
//    @State private var task: RolyTask

    init(position: Int, date: Date, isOpaque: Binding<Bool>) {
        self.position = position
        self.date = date
        self._isOpaque = isOpaque
        
        // Use precise date filtering by day
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<RolyTask> { task in
            task.position == position &&
            task.dueDate >= startOfDay &&
            task.dueDate < endOfDay
        }
        
        self._tasks = Query(filter: predicate, sort: \.dueDate)
//        self._task = State(initialValue: RolyTask(title: "", note: "", dueDate: date, position: position))
    }
    
    private var existingTask: RolyTask? {
        return tasks.first
    }
    
    private var shouldBeOpaque: Bool {
        isTextFieldFocused || !taskTitle.isEmpty
    }
    
    var body: some View {
        NavigationLink(destination: {
            // If we have an existing task, edit it
            // Otherwise create a new one with the correct date and position
            if let task = existingTask {
                EditTaskView(task: task)
                    .environment(\.modelContext, modelContext)
            } else {
                let newTask = RolyTask(
                    title: "",
                    note: "",
                    dueDate: date,
                    position: position
                )
                EditTaskView(task: newTask)
                    .environment(\.modelContext, modelContext)
            }
        }) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: shouldBeOpaque ? 4 : 2)
                    .frame(
                        width: shouldBeOpaque ? 12 : 8,
                        height: shouldBeOpaque ? 12 : 8
                    )
                    .opacity(shouldBeOpaque ? 1.0 : 0.2)
                TextField("Task \(position) in \(monthName) \(dayNumber)", text: $taskTitle)
                    .focused($isTextFieldFocused)
                    .font(shouldBeOpaque ? .headline : .caption)
                    .onChange(of: shouldBeOpaque) {
                        isOpaque = shouldBeOpaque
                    }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .opacity(shouldBeOpaque ? 1.0 : 0.2)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if let task = existingTask {
                taskTitle = task.title
            } else {
                taskTitle = ""
            }
        }
        .onChange(of: taskTitle) { _, newValue in
            // Update the existing task or create a new one when title changes
            if let task = existingTask {
                task.title = newValue
            } else if !newValue.isEmpty {
                let newTask = RolyTask(
                    title: newValue,
                    note: "",
                    dueDate: date,
                    position: position
                )
                modelContext.insert(newTask)
            }
        }
    }
    
    private var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Full month name
        return formatter.string(from: date)
    }
    
    private var dayNumber: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RolyTask.self, configurations: config)
    return EditTaskListView()
        .modelContainer(container)
}
