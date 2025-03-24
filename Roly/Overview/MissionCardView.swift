//
//  MissionCardView.swift
//  Roly
//
//  Created by 劉采璇 on 3/21/25.
//

import SwiftUI

struct MissionCardView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var topPriority: String
    @State private var mission: String
    @State private var strategies: [String]
    @State private var objectives: [String]
    @State private var navigateToEditMission: Bool = false
    
    init(topPriority: String, mission: String, strategies: [String], objectives: [String]) {
        self._topPriority = State(initialValue: topPriority)
        self._mission = State(initialValue: mission)
        self._strategies = State(initialValue: strategies)
        self._objectives = State(initialValue: objectives)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 30) {
                    Text(topPriority)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(mission)
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(strategies, id: \.self) { strategy in
                            StrategyRow(strategy: strategy)
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Q1")
                                .font(.caption)
                                .padding(.top, 10)
                            ForEach(0..<2) { index in
                                if index < objectives.count {
                                    ObjectiveDisplayRow(objective: objectives[index])
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Q2")
                                .font(.caption)
                                .padding(.top, 10)
                            ForEach(2..<4) { index in
                                if index < objectives.count {
                                    ObjectiveDisplayRow(objective: objectives[index])
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Q3")
                                .font(.caption)
                                .padding(.top, 10)
                            ForEach(4..<6) { index in
                                if index < objectives.count {
                                    ObjectiveDisplayRow(objective: objectives[index])
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Q4")
                                .font(.caption)
                                .padding(.top, 10)
                            ForEach(6..<8) { index in
                                if index < objectives.count {
                                    ObjectiveDisplayRow(objective: objectives[index])
                                }
                            }
                        }
                    }
                }
                Spacer()
                GrayPinkButtons(
                    showingDeleteConfirmation: .constant(false),
                    title: .constant(nil),
                    onSave: { navigateToEditMission = true },
                    onDiscard: { dismiss() },
                    useEdit: true
                )
            }
            .padding(.horizontal, 30)
            .navigationDestination(isPresented: $navigateToEditMission) {
                EditMissionListView(
                    topPriority: topPriority,
                    mission: mission,
                    strategies: strategies,
                    objectives: objectives,
                    onSave: { newTopPriority, newMission, newStrategies, newObjectives in
                        // Update local state with edited values
                        topPriority = newTopPriority
                        mission = newMission
                        strategies = newStrategies
                        objectives = newObjectives
                        viewModel.currentUser?.topPriority = newTopPriority
                        viewModel.currentUser?.mission = newMission
                        viewModel.currentUser?.strategies = newStrategies
                        viewModel.currentUser?.objectives = newObjectives
                        viewModel.updateUserMission()  // Persist changes
                        navigateToEditMission = false  // Reset navigation state
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// StrategyRow and ObjectiveDisplayRow remain unchanged

#Preview {
    NavigationStack {
        MissionCardView(
            topPriority: "Personal",
            mission: "Be a wonderful unicorn",
            strategies: ["Test strategy 1", "Test strategy 2"],
            objectives: ["Apple", "Banana", "Orange", "Strawberry", "Blueberry", "", "Pineapple", "Mango"]
        )
    }
    .environmentObject(AuthViewModel())
    .navigationBarBackButtonHidden()
}

struct ObjectiveDisplayRow: View {
    let objective: String
    
    var body: some View {
        if !objective.isEmpty {
            HStack(spacing: 12) {
                Image(systemName: "target")
                    .font(.caption)
                Text(objective)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

struct StrategyRow: View {
    let strategy: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "inset.filled.diamond")
                .font(.caption)
            Text(strategy)
                .lineLimit(1)
            Spacer()
            Text("24000")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(width: 50, height: 20)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .font(.caption)
        }
    }
}
