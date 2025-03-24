//
//  RolyView.swift
//  Roly
//
//  Created by 劉采璇 on 3/2/25.
//

import SwiftUI
import SwiftData

struct RolyView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var selectedDate = Date.now
    @State private var sheetIsPresented = false
    @State private var selectedPosition = 1
    @State private var notificationEnabled = true
    @Environment(\.colorScheme) var colorScheme

    private var isSelectedDateToday: Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: Date.now)
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack(spacing: 15) {
                    // HEADER
                    HStack {
                        NavigationLink(destination: ProfileView()) {
                            HStack {
                                Text(user.initials)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.rolyMainPink/*.opacity(0.2)*/)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text("Welcome to Roly 2025,")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.rolyMainPink)
                                    Text(user.fullname)
                                        .font(.headline)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                    Text(user.quote)
                                        .font(.caption)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                }
                            }
                        }
                        Spacer()
                        
                        //                    DateHeaderView(date: selectedDate)
                        DateHeaderView(isToday: isSelectedDateToday, onTap: { selectedDate = Date.now })
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    AddTaskCardView(
                        selectedDate: $selectedDate,
                        sheetIsPresented: $sheetIsPresented,
                        selectedPosition: $selectedPosition
                    )
                    
                    ButtonFooterView()
                        .padding(.horizontal, 33)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}

// MARK: DATE - HEADERVIEW
struct DateHeaderView: View {
    // Remove the date parameter and always use today's date
    private var today: Date {
        Date.now // Always show current date (March 10, 2025 in this context)
    }
    
    let isToday: Bool // 新增屬性來判斷是否為今日
    let onTap: () -> Void // Add tap action closure
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(monthAbbreviation(for: today))
                .font(.system(size: 13))
            Divider()
                .frame(width: 45, height: 1)
                .background(Color.black)
            Text(String(format: "%02d", today.day))
                .font(.system(size: 33, weight: .medium))
        }
        .opacity(isToday ? 1.0 : 0.5)
        .onTapGesture {
            onTap() // Trigger scroll to today when tapped
        }
    }
    
    // Get month abbreviation (e.g., "MAR")
    private func monthAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM" // Get month abbreviation
        return formatter.string(from: date).uppercased()
    }
}

// MARK: BUTTOM BUTTON
struct ButtonFooterView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var sheetIsPresented = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            HStack {
                HStack (spacing: 63) {
                    NavigationLink {
                        OverviewView(
                            topPriority: "",
                            mission: "",
                            strategies: [""],
                            objectives: ["", "", "", "", "", "", "", ""]
                        )
                        .environmentObject(viewModel)
                    } label: {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 27)
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    Button {
                        //                    TODO
                    } label: {
                        Image(systemName: "rectangle.and.text.magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 27)
                    }
                }
                .foregroundStyle(.rolyMainPink)
                .frame(width: 239, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.rolyMainPink, lineWidth: 1.5)
                )
                Spacer()
                
                ZStack {
                    Image(systemName: "plus")
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .font(.headline)
                        .frame(width: 70, height: 70)
                        .background(
                            Circle()
                                .fill(.rolyMainPink)
                        )
                }
            }
        }
    }
}



#Preview {
    RolyView()
        .environmentObject({
            let vm = AuthViewModel()
            vm.currentUser = User.MOCK_USER
            return vm
        }()) // 使用閉包初始化並注入 viewModel
        .modelContainer(for: RolyTask.self, inMemory: true)
        .environment(\.locale, .init(identifier: "en_US"))
}

