//
//  RolyTask.swift
//  Roly
//
//  Created by 劉采璇 on 3/6/25.
//

import Foundation
import SwiftData
import SwiftUI

enum TaskTheme: String, Codable {
    case rolyMainPink
    case rolyLightPink
    
    var mainColor: Color {
        switch self {
        case .rolyMainPink:
            return Color("rolyMainPink") // Load from asset catalog
        case .rolyLightPink:
            return Color("rolyLightPink") // Load from asset catalog
//        Color("rawValue") // 從 Color Asset 載入
        }
    }
}

@Model
class RolyTask {
    var title: String
    var note: String
    var dueDate: Date
    var position: Int
    var notificationEnabled : Bool
    // C
    var notificationTime: Date
//    var createdAt: Date
    // G
    var theme: TaskTheme // Now Codable and RawRepresentable
    
    init(
        title: String = "",
        note: String = "",
        dueDate: Date = Date(),
        position: Int = 1,
        notificationEnabled: Bool = false,
        // Default to now + 1 hour
        notificationTime: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date.now)!,
        theme: TaskTheme = .rolyMainPink
    ) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.position = position
        self.notificationEnabled = notificationEnabled
        // C
        self.notificationTime = notificationTime
//        self.createdAt = .now
        // G
        self.theme = theme
    }
    
    var formattedNotificationTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: notificationTime) // Always returns a time since notificationTime is never nil
    }
    
    func progress(totalTime: TimeInterval = 24 * 60 * 60) -> Double {
            let startTime = notificationTime.addingTimeInterval(-totalTime)
            let now = Date()
            guard now >= startTime else { return 0.0 }
            let elapsed = now.timeIntervalSince(startTime)
            let progress = elapsed / totalTime
            return min(max(progress, 0.0), 1.0)
        }
}

extension RolyTask {
    static var sampleTasks: [RolyTask] {
        return [
            RolyTask(
                title: "Grocery Shopping",
                note: "Buy milk, eggs, bread, bacon, toilet paper, milk, eggs, bread, bacon, toilet paper, milk, eggs, bread, bacon, toilet paper, milk, eggs, bread, bacon, toilet paper!",
                //                dueDate: calendar.startOfDay(for: now),
                position: 1,
                notificationEnabled: true,
                notificationTime: Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: Date.now)!,
                theme: .rolyMainPink // 更新為新主題
            ),
            RolyTask(
                title: "Finish Homework",
                note: "Math, Physics, English, Coding, Chinese, Spanish, French, German, Italian, Japanese, Korean, Russian, Korean, Russian, Science, History, Geography, Chemistry!",
                //                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                position: 2,
                notificationEnabled: true,
                notificationTime: Calendar.current.date(bySettingHour: 14, minute: 30, second: 0, of: Date.now)!,
                theme: .rolyMainPink
            ),
            RolyTask(
                title: "Call Mom",
                note: "Check in and say hi",
                //                dueDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
                position: 3,
                notificationEnabled: true,
                notificationTime: Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date.now)!,
                theme: .rolyMainPink
            )
        ]
    }
}

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
}

extension Calendar {
    func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
        return isLeapYear
    }
}
