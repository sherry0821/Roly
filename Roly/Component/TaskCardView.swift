//
//  TaskCardView.swift
//  Roly
//
//  Created by 劉采璇 on 3/4/25.
//

import SwiftUI
import SwiftData

struct TaskCardView: View {
    @Environment(\.modelContext) var modelContext
    @State private var task: RolyTask
    @State private var isExpanded = false
    
    let totalTime: TimeInterval = 24 * 60 * 60 // 固定 24 小時（單位：秒）
        
    // 每秒更新計時器
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(task: RolyTask) {
        self._task = State(initialValue: task)
    }
    
    var body: some View {
        ZStack {
            if isExpanded {
                Color.white.opacity(0.01)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isExpanded = false
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: isExpanded ? 25 : 15) {
                HStack {
                    Text(task.title)
                        .font(isExpanded ? .title : .headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black) // 使用動態 accentColor
                        .lineLimit(isExpanded ? nil : 1) // 無限：單行
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    
                    if isExpanded {
                        Spacer()
                        
                        NavigationLink {
                            EditTaskView(task: task)
                                .environment(\.modelContext, modelContext)
                        } label: {
                            Image(systemName: "highlighter")
                                .foregroundColor(Color.black)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Text(task.note)
                    .font(isExpanded ? .body : .caption)
                    .foregroundColor(Color.black) // 使用動態 accentColor
                    .lineLimit(isExpanded ? nil : 3) // 無限：三行
                    .truncationMode(.tail) // 超出顯示 "..."
                    .multilineTextAlignment(.leading)
                
                HStack (alignment: .center, spacing: isExpanded ? 7 : 3) {                    
                    ProgressView(value: task.progress(totalTime: totalTime), total: 1.0)
                    // Simplified, no need for ?? since task is non-nil
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(Color.black)
                        .padding(.trailing, 4)
                    
                    // Conditionally show bell icon while maintaining space
                    if task.notificationEnabled {
                        Image(systemName: "bell.fill")
                            .font(isExpanded ? .body : .caption2)
                            .foregroundColor(Color.black)
                            .frame(width: isExpanded ? 25 : 20) // Fixed width to match spacer
                    } else {
                        Spacer()
                            .frame(width: 20) // Maintains consistent spacing
                    }
                    
                    Text(task.formattedNotificationTime)
                        .font(isExpanded ? .headline : .caption)
                        .fontWeight(isExpanded ? .bold : .semibold)
                        .foregroundColor(Color.black) // 使用動態 accentColor
                }
            }
            .padding(isExpanded ? 34 : 24)
            .frame(width: isExpanded ? 330 : 160,
                   height: isExpanded ? 330 : 160)
            .background(Color.rolyMainPink)
            .cornerRadius(34)
            .onTapGesture {
                if !isExpanded {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded = true
                    }
                }
            }
        }
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a preview container and task
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: RolyTask.self, configurations: config)
        
        let sampleTask = RolyTask.sampleTasks[0]
        container.mainContext.insert(sampleTask)
        
        return NavigationStack {
            TaskCardView(task: sampleTask)
        }
        .previewLayout(.fixed(width: 300, height: 300))
        .modelContainer(container)
    }
}
