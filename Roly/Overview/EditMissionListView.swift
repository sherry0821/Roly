//
//  EditMissionListView.swift
//  Roly
//
//  Created by 劉采璇 on 3/16/25.
//

import SwiftUI

struct EditMissionListView: View {
    @Environment(\.modelContext) var modelContext
//    @Query private var tasks: [RolyTask]
    
    @State private var topPriority: String
    @State private var mission: String
    @State private var strategies: [String]
    @State private var objectives: [String]
    @State private var showingDeleteConfirmation = false
        
    @State private var activeTab: TabModel = .mission
    
    @Environment(\.dismiss) var dismiss
    let onSave: (String, String, [String], [String]) -> Void
    private let maxCharacters = 50
    
    init(topPriority: String,
         mission: String,
         strategies: [String],
         objectives: [String],
         onSave: @escaping (String, String, [String], [String]) -> Void
    ) {
        _topPriority = State(initialValue: topPriority)
        _mission = State(initialValue: mission)
        _strategies = State(initialValue: strategies.isEmpty ? [""] : strategies)
        _objectives = State(initialValue: objectives.count == 8 ? objectives : ["", "", "", "", "", "", "", ""])
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    CustomTabBar(activeTab: $activeTab)
                    
                    // Tab-based content switching
                    switch activeTab {
                    case .mission:
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Mission", text: $mission)
                                .lineLimit(1)
                                .frame(height: 100)
                            
                            HStack {
                                Text("Set a long-term mission for 3-12 months")
                                    .font(.caption2)
                                Spacer()
                                Text("\(mission.count)/\(maxCharacters)")
                                    .font(.caption2)
                                    .onChange(of: mission) { oldValue, newValue in
                                        if newValue.count > self.maxCharacters {
                                            self.mission = String(oldValue.prefix(self.maxCharacters))
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 30)
                        
                    case .strategy:
                        EditStrategyListView(strategies: $strategies)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.horizontal)
                        
                    case .objective:
                        EditObjectiveListView(objectives: $objectives)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .containerRelativeFrame(.horizontal)
                        
                    case .tasks:
                        EditTaskListView()
                            .environment(\.modelContext, modelContext)
                            .frame(height: 540)
                            .containerRelativeFrame(.horizontal)
                        
                    case .preview:
                        EmptyView() // Assuming preview isn't needed here, adjust if necessary
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("")  // Empty string as we're using a custom view
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        TextField("Top priority", text: $topPriority, axis: .vertical)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(width: 300, height: 70, alignment: .leading)
                            .multilineTextAlignment(.leading)
                                                
                        Text("\(topPriority.count)/ \(maxCharacters)")
                            .font(.caption2)
                            .frame(width: 35,alignment: .trailing)
                            .onChange(of: topPriority) { oldValue, newValue in
                                if newValue.count > self.maxCharacters {
                                    self.topPriority = String(oldValue.prefix(self.maxCharacters))
                                }
                            }
                            .lineLimit(1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
//            .searchable(text: $searchText,
//                        isPresented: $isSearchActive,
//                        placement: .navigationBarDrawer(displayMode: .automatic))
            .onChange(of: topPriority) { oldValue, newValue in
                if newValue.count > maxCharacters {
                    topPriority = String(newValue.prefix(maxCharacters))
                }
            }
            
            // Delete and Save
            GrayPinkButtons(
                showingDeleteConfirmation: $showingDeleteConfirmation,
                title: .constant(nil),
                onSave: {
                    let nonEmptyStrategies = strategies.filter { !$0.isEmpty }
                    onSave(topPriority, mission, nonEmptyStrategies, objectives)
                    dismiss()
                },
                onDiscard: {}
            )
            .padding(.horizontal, 30)
        }
        .navigationBarBackButtonHidden()
    }
}

struct CustomTabBar: View {
    @Binding var activeTab: TabModel
    @Environment(\.colorScheme) private var scheme
    
    
    var body: some View {
        GeometryReader { _ in
            HStack {
                HStack(spacing: activeTab == .preview ? -5 : 8) {
                    ForEach(TabModel.allCases.filter({ $0 != .preview }), id: \.rawValue) { tab in
                        ResizableTabButton(tab)
                    }
                }
                
                if activeTab == .preview {
                    ResizableTabButton(.preview)
                        .transition(.offset(x: 300))
                }
            }
            .padding(.horizontal, 30)
        }
        .frame(height: 50)
    }
    
    @ViewBuilder
    func ResizableTabButton(_ tab: TabModel) -> some View {
        HStack(spacing: 12) {
            Image(systemName: tab.symbolImage)
                .symbolVariant(activeTab == tab ? .fill : .none)
            
            if activeTab == tab {
                Text(tab.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.trailing, 5)
            }
        }
        .font(activeTab == tab ? .headline : .caption)
        .foregroundStyle(tab == .preview || activeTab == tab ? schemeColor : antiSchemeColor)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: activeTab == tab ? .infinity : 50)
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(tab == .preview || activeTab == tab ? antiSchemeColor : activeTab == tab ? Color.gray : Color.gray.opacity(0.5)
        ))
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
            .fill(schemeColor)
            .padding(activeTab == .preview && tab != .preview ? -3 : 3)
        )
        .onTapGesture {
            guard tab != .preview else { return }
            withAnimation(.bouncy) {
                if activeTab == tab {
                    activeTab = .preview
                } else {
                    activeTab = tab
                }
            }
        }
    }
    
    var schemeColor: Color {
        scheme == .dark ? .black : .white
    }
    var antiSchemeColor: Color {
        scheme == .light ? .black : .white
    }
}

#Preview {
    EditMissionListView(
        topPriority: "Personal",
        mission: "Test Mission",
        strategies: ["Test strategy 1", "Test strategy 2"],
        objectives: ["Apple", "Banana", "Orange", "Strawberry", "Blueberry", "Kiwi", "Pineapple", "Mango"],
        onSave: { _, _, _, _ in})
}

enum TabModel: String, CaseIterable {
    case mission = "Mission"
    case strategy = "Strategy"
    case objective = "Objective"
    case tasks = "Tasks"
    case preview = "Preview"
    
    var color: Color {
        switch self {
        case .mission: .blue
        case .strategy: .green
        case .objective: .indigo
        case .tasks: .pink
        case .preview: .white
        }
    }
    
    var symbolImage: String {
        switch self {
        case .mission: "flag.pattern.checkered"
        case .strategy: "inset.filled.diamond"
        case .objective: "target"
        case .tasks: "plus"
        case .preview: "magnifyingglass"
        }
    }
}
