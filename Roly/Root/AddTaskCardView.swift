//
//  AddTaskCardView.swift
//  Roly
//
//  Created by 劉采璇 on 3/4/25.
//

import SwiftUI
import SwiftData

struct AddTaskCardView: View {
    @Binding var selectedDate: Date
    @Binding var sheetIsPresented: Bool
    @Binding var selectedPosition: Int
    @State private var notificationEnabled = true
    @State private var notificationTime = Date.now
    
    // Generate all dates for the year
    private var allDates: [Date] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date.now)
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        
        let daysInYear = calendar.isLeapYear(year) ? 366 : 365
        
        return (0..<daysInYear).map { day in
            calendar.date(byAdding: .day, value: day, to: startOfYear)!
        }
    }
    
    // Find the index of today's date
    private var initialIndex: Int {
        let calendar = Calendar.current
        let today = Date.now
        return allDates.firstIndex(where: {
            calendar.isDate($0, inSameDayAs: today)
        }) ?? 0
    }
    
    var body: some View {
        GeometryReader {
//            let size = $0.size
            let padding = max(0, ($0.size.width * 0.5) - 40)
            
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(allDates, id: \.timeIntervalSince1970) { date in
                            DayCollectionView(
                                date: date,
                                sheetIsPresented: $sheetIsPresented,
                                selectedDate: .constant($selectedDate),
                                selectedPosition: .constant($selectedPosition)
                            )
                            .id(date.timeIntervalSince1970)
                            .animation(.easeInOut(duration: 0.3), value: selectedDate)
                            .frame(maxWidth: .infinity)
                            .scrollTransition { content, phase  in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.5)
                                    .scaleEffect(phase.isIdentity ? 1.1 : 1)
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 20)
                }
                .scrollTargetBehavior(.viewAligned)
                .safeAreaPadding(.horizontal, padding/*(size.width * 0.5) - 70*/)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let todayDate = allDates[initialIndex]
                        scrollProxy.scrollTo(todayDate.timeIntervalSince1970, anchor: .center)
                    }
                }
                .onChange(of: sheetIsPresented) { _, newValue in
                    if !newValue { // Sheet dismissed after save
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scrollProxy.scrollTo(selectedDate.timeIntervalSince1970, anchor: .center)
                        }
                    }
                }
                .onChange(of: selectedDate) { _, newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        let todayDate = allDates[initialIndex]
                        // 使用 withAnimation 區塊為 scrollTo 加入動畫效果
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scrollProxy.scrollTo(todayDate.timeIntervalSince1970, anchor: .center)
                        }
                    }
                    print("AddTaskCardView - selectedDate changed to: \(newValue)")
                }
            }
            .sheet(isPresented: $sheetIsPresented){
                NavigationStack {
                    EditTaskView(
                        task: RolyTask(
                            dueDate: selectedDate,
                            position: selectedPosition,
                            notificationEnabled: true,
                            notificationTime: notificationTime
                        )
                    )
                }
                .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    AddTaskCardView(
        selectedDate: .constant(Date()),
        sheetIsPresented: .constant(false),
        selectedPosition: .constant(1)
    )
    .modelContainer(for: RolyTask.self, inMemory: true)
}
