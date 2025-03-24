//
//  SurveyView.swift
//  Roly
//
//  Created by 劉采璇 on 3/13/25.
//

import SwiftUI

struct SurveyView: View {
    @StateObject private var surveyVM = SurveyViewModel()
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selectedTime = Date()
    @State private var selectedDays: [String] = []
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                VStack {
                    if surveyVM.currentPage == 0 {
                        // Introduction Screen
                        VStack(spacing: 20) {
                            Text("Hi, \(user.fullname)")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.rolyMainPink)
                            Text("Before you start, we have just 5 questions!")
                                .font(.callout)
                            Spacer()
                            Image(systemName: "flag.fill")
                                .font(.custom("Poppins-Bold", size: 100))
                                .rotationEffect(.degrees(-45))
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    surveyVM.currentPage += 1
                                }
                            }) {
                                Text("Let's do it!")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 25)
                                    .background(
                                        Capsule()
                                            .fill(Color.rolyMainPink)
                                    )
                            }
                        }
                        .padding(.vertical, 100)
                        
                    } else if surveyVM.currentPage <= 5 {
                        // Survey Questions
                        surveyQuestionView(page: surveyVM.currentPage)
                    } else if surveyVM.currentPage == 6 {
                        // Completion
                        VStack(spacing: 40) {
                            Text("Thank you for completing the survey!")
                                .font(.title2)
                            Button("Continue to Roly") {
                                surveyVM.surveyCompleted = true
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.rolyMainPink)
                        }
                    } else {
                        // 如果 currentPage 超過 6，可以添加額外處理
                        EmptyView()
                    }
                }
                .navigationDestination(isPresented: $surveyVM.surveyCompleted) {
                    RolyView()
                }
            } else {
                Text("Please log in to continue")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    func surveyQuestionView(page: Int) -> some View {
        VStack(alignment: .leading, spacing: 40) {
            ProgressView(value: Double(page), total: 5)
                .tint(.rolyMainPink)
                .padding(.top, 20)

            switch page {
            case 1:
                Text("What is your experience with time management?")
                    .font(.custom("Fredoka", size: 40))
                HStack(spacing: 20) {
                        ForEach(["None", "A little", "A lot"], id: \.self) { option in
                            Button(action: {
                                surveyVM.responses.timeManagementExperience = option
                            }) {
                                Text(option)
                                    .font(.headline)
                                    .foregroundColor(surveyVM.responses.timeManagementExperience == option ? .white : .black)
                                    .frame(width: 100, height: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 34)
                                            .stroke(surveyVM.responses.timeManagementExperience == option ? Color.clear : Color.black)
                                            .fill(surveyVM.responses.timeManagementExperience == option ?
                                                  Color.rolyMainPink : Color.clear)
                                    )
                            }
                        }
                    }
                
            case 2:
                Text("What is your top priority role to manage?")
                    .font(.custom("Fredoka", size: 40))

                HStack(spacing: 20) {
                    ForEach(["Personal", "Family", "Community"], id: \.self) { option in
                        Button(action: {
                            surveyVM.responses.topPriority = option
                        }) {
                            VStack(spacing: 10) {
                                Text(option)
                                    .font(.headline)
                                    .foregroundColor(surveyVM.responses.topPriority == option ? .white : .black)
                            }
                            .frame(width: 100, height: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 34)
                                    .stroke(surveyVM.responses.topPriority == option ? Color.clear : Color.black)
                                    .fill(surveyVM.responses.topPriority == option ?
                                          Color.rolyMainPink : Color.clear)
                            )
                        }
                    }
                }
                TextField("Custom role", text: Binding(
                    get: { surveyVM.responses.topPriority ?? "" },
                    set: { surveyVM.responses.topPriority = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                Text("You can always change or add roles later.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            case 3:
                Text("What specific goal do you have for yourself?")
                    .font(.custom("Fredoka", size: 40))
                TextField("Your goal", text: Binding(
                    get: { surveyVM.responses.goal ?? "" },
                    set: { surveyVM.responses.goal = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                Text("You can always change or add goals later.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            case 4:
                Text("How often do you plan to use Roly?")
                    .font(.custom("Fredoka", size: 40))
                
                 HStack(spacing: 20) {
                     ForEach(["Daily", "Weekly", "Occasionally"], id: \.self) { option in
                         Button(action: {
                             surveyVM.responses.usageFrequency = option
                         }) {
                             VStack(spacing: 10) {
                                 Text(option)
                                     .font(.headline)
                                     .foregroundColor(.white)
                             }
                             .frame(width: 100, height: 100)
                             .background(
                                 RoundedRectangle(cornerRadius: 34)
                                     .fill(surveyVM.responses.usageFrequency == option ?
                                           Color.rolyMainPink : Color.gray.opacity(0.5))
                             )
                         }
                     }
                 }
                 
                notificationSettingsView(frequency: surveyVM.responses.usageFrequency ?? "")
                
                Text("You can always change or close the notification later.")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            case 5:
                Text("Which features interest you most?")
                    .font(.custom("Fredoka", size: 40))
                MultiSelectPicker(
                    options: ["AAAAAAAAAAAA", "BBBBBBBBBBBBB", "CCCCCCCCCCCCCCC", "DDDDDDDDDDDDD", "EEEEEEEEEEE"],
                    selections: $surveyVM.responses.interestedFeatures
                )
                
            default:
                EmptyView()
            }
            
            Spacer()
            
            GrayPinkButtons(
                showingDeleteConfirmation: .constant(false), // No delete confirmation in survey
                title: .constant(nil), // No title tracking needed
                onSave: {
                    if surveyVM.currentPage < 5 {
                        surveyVM.currentPage += 1 // Next page
                    } else {
                        // Final save to Firebase
//                        surveyVM.surveyCompleted = true
                        if let userId = viewModel.currentUser?.id {
                            surveyVM.saveSurveyResponses(userId: userId)
                            var updatedUser = viewModel.currentUser!
                            updatedUser.topPriority = surveyVM.responses.topPriority
                            updatedUser.mission = surveyVM.responses.goal
                            if updatedUser.objectives.count != 8 {
                                updatedUser.objectives = ["", "", "", "", "", "", "", ""]
                            }
                            viewModel.currentUser = updatedUser
                            viewModel.updateUserMission()
                        }
                        surveyVM.currentPage += 1 // 進入感謝頁面
                    }
                },
                onDiscard: {
                    if surveyVM.currentPage > 1 {
                        surveyVM.currentPage -= 1 // Previous page
                    }
                },
                showDiscardButton: page > 1,
                useArrows: true
            )
            .disabled(!isPageComplete(page: page))
            .opacity(isPageComplete(page: page) ? 1 : 0.2)
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    func notificationSettingsView(frequency: String) -> some View {
        switch frequency {
        case "Daily":
            DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .onChange(of: selectedTime) { _, newValue in
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    surveyVM.responses.notificationTime = formatter.string(from: newValue)
                }
        case "Weekly":
            MultiSelectPicker(
                options: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                selections: $selectedDays
            )
            .onChange(of: selectedDays) { _, newValue in
                surveyVM.responses.notificationDays = newValue
            }
        case "Occasionally":
            Text("Custom schedule coming soon!")
        default:
            EmptyView()
        }
    }
    
    func isPageComplete(page: Int) -> Bool {
        switch page {
        case 1:
            return surveyVM.responses.timeManagementExperience != nil &&
                   surveyVM.responses.timeManagementExperience?.isEmpty == false
        case 2:
            return surveyVM.responses.topPriority != nil &&
                   surveyVM.responses.topPriority?.isEmpty == false
        case 3:
            return surveyVM.responses.goal != nil &&
                   surveyVM.responses.goal?.isEmpty == false
        case 4:
            return surveyVM.responses.usageFrequency != nil &&
                   surveyVM.responses.usageFrequency?.isEmpty == false
        case 5:
            return !surveyVM.responses.interestedFeatures.isEmpty
        default:
            return false
        }
    }
    
    private func getImageName(for option: String) -> String {
        switch option {
        case "None": return "clock"
        case "A little": return "timer"
        case "A lot": return "checkmark.circle"
        default: return "questionmark"
        }
    }
}

// Helper View for multiple selections
struct MultiSelectPicker: View {
    let options: [String]
    @Binding var selections: [String]
    
    var body: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selections.contains(option) {
                        selections.removeAll { $0 == option }
                    } else {
                        selections.append(option)
                    }
                }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selections.contains(option) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let authVM = AuthViewModel()
    authVM.currentUser = User(
        id: "test123",
        fullname: "Test User",
        quote: "Test Quote",
        email: "test@example.com",
        topPriority: nil,
        mission: nil,
        strategies: [],
        objectives: []
    )
    return SurveyView()
        .environmentObject(authVM)
        .preferredColorScheme(.light)
}
