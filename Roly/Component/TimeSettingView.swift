//
//  TimeSettingView.swift
//  Roly
//
//  Created by 劉采璇 on 3/19/25.
//

import SwiftUI

struct TimeSettingView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Text("10,000 \nhr")
                    .frame(width: 150, height: 150)
                    .background(RoundedRectangle(cornerRadius: 34)
                        .fill(Color.blue.opacity(0.5)))
                
                VStack(alignment: .leading) {
                    Text("Every 1 day 1 minute 1 times lasting 3 months.")
                        .font(.caption)
                    HStack {
                        Text("Every")
                        Text("1")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("day")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("week")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                            .opacity(0.5)
                        Text("month")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                            .opacity(0.5)
                        Text("year")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                            .opacity(0.5)
                    }
                    
                    HStack(spacing: 10) {
                        Text("1")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("min")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("hr")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Text("1")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("times")
                    }
                    HStack {
                        Text("lasting")
                        Text("3")
                            .frame(width: 50, height: 50)
                            .background(RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue.opacity(0.5)))
                        Text("Month")
                    }
                }
            }
            
            HStack {
                Text("Start from right now!")
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.rolyMainPink))
                Text("Start from tomorrow!")
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(Color.rolyMainPink))
            }
        }
    }
}

#Preview {
    TimeSettingView()
}
