//
//  OverviewView2.swift
//  Roly
//
//  Created by 劉采璇 on 3/20/25.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var topPriority: String
    @State private var mission: String
    @State private var strategies: [String]
    @State private var objectives: [String]
    
    @Environment(\.dismiss) var dismiss
    @State private var navigateToEditMission: Bool = false
    @State private var navigateToAddNew: Bool = false
    
    init(topPriority: String,
         mission: String,
         strategies: [String],
         objectives: [String]
    ) {
        self.topPriority = topPriority
        self.mission = mission
        self.strategies = strategies
        self.objectives = objectives
    }
    
    var body: some View {
        VStack {
            HStack {
                // Top Priority 1
                Text(viewModel.currentUser?.topPriority ?? topPriority)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .multilineTextAlignment(.leading)
                Spacer()
                // TODO: Top Priority 2
//                Text("Add new")
            }
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1), spacing: 20) {
                    MissionCard(
                        strategies: strategies, objectives: objectives
                    )
                }
            }
            GrayPinkButtons(
                showingDeleteConfirmation: .constant(false),
                title: .constant(nil),
                onSave: {
                    navigateToEditMission = true
                },
                onDiscard: {
                    dismiss()
                },
                useEdit: true
            )
        }
        .padding(.horizontal, 30)
        .navigationDestination(isPresented: $navigateToEditMission) {
            EditMissionListView(
                topPriority: viewModel.currentUser?.topPriority ?? topPriority,
                mission: viewModel.currentUser?.mission ?? mission,
                strategies: viewModel.currentUser?.strategies ?? strategies,
                objectives: viewModel.currentUser?.objectives ?? objectives,
                onSave: { newTopPriority, newMission, newStrategies, newObjectives in
                    viewModel.currentUser?.topPriority = newTopPriority
                    viewModel.currentUser?.mission = newMission
                    viewModel.currentUser?.strategies = newStrategies
                    viewModel.currentUser?.objectives = newObjectives
                    viewModel.updateUserMission()
                    dismiss()
                }
            )
        }
    }
}

struct MissionCard: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let strategies: [String]
    let objectives: [String]
    
    init(strategies: [String], objectives: [String]) {
        self.strategies = strategies
        self.objectives = objectives
    }

    var body: some View {
        NavigationLink(destination: MissionCardView(
            topPriority: "Test from overviewview",
            mission: "Test from overviewview2",
            strategies: strategies,
            objectives: objectives
        )) {
            
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .foregroundStyle(Color.rolyMainPink)
                    .opacity(0.2)
                    .frame(width: 340, height: 340)
                
                HStack {
                    // Left: Mission, hour, tasks number
                    VStack(alignment: .leading) {
                        Text(viewModel.currentUser?.mission ?? "Mission")
                            .font(.title)
                            .padding(.top, 34)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Grid(alignment: .leading, horizontalSpacing: 30, verticalSpacing: -30) {
                            GridRow {
                                Image(systemName: "inset.filled.diamond")
                                    .frame(maxHeight: .infinity)
                                    .gridColumnAlignment(.center)
                                VStack(alignment: .leading) {
                                    Text("Strategy")
                                        .font(.caption)
                                    HStack(alignment: .bottom) {
                                        Text("\(strategies.count)")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("/ 5")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            GridRow {
                                Image(systemName: "target")
                                    .frame(maxHeight: .infinity)
                                    .gridColumnAlignment(.center)
                                VStack(alignment: .leading) {
                                    Text("Objective")
                                        .font(.caption)
                                    HStack(alignment: .bottom) {
                                        Text("\(objectives.count)")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                        Text("/ 8")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            GridRow {
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .frame(width: 12, height: 12)
                                    RoundedRectangle(cornerRadius: 2)
                                        .frame(width: 8, height: 8)
                                }
                                .frame(maxHeight: .infinity)
                                .gridColumnAlignment(.center)
                                
                                VStack(alignment: .leading) {
                                    Text("Tasks")
                                        .font(.caption)

                                    HStack(alignment: .bottom) {
                                        Text("672")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                        .padding(.leading, 20)
                        .frame(width: 170, height: 170, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.5)))
                        .padding(10)
                    }
                    .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(Color.white)
                            .frame(width: 100, height: 100)
                            .background(RoundedRectangle(cornerRadius: 34).fill(Color.rolyMainPink))
                    }
                    .padding(10)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OverviewView(
            topPriority: "Personal",
            mission: "Test Mission",
            strategies: ["Test strategy 1", "Test strategy 2"],
            objectives: ["Apple", "Banana", "Orange", "Strawberry", "Blueberry", "Kiwi", "Pineapple", "Mango"]
        )
    }
    .environmentObject(AuthViewModel())
}
