//
//  SurveyViewModel.swift
//  Roly
//
//  Created by 劉采璇 on 3/13/25.
//

//
//  SurveyViewModel.swift
//  Roly
//
//  Created by 劉采璇 on 3/13/25.
//

import Foundation
import Firebase

struct SurveyResponse {
    var timeManagementExperience: String?
    var topPriority: String?
    var goal: String?
    var usageFrequency: String?
    var notificationTime: String?
    var notificationDays: [String] = []
    var interestedFeatures: [String] = []
}

class SurveyViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var surveyCompleted = false
    @Published var responses = SurveyResponse()
    
    func saveSurveyResponses(userId: String) {
        guard !userId.isEmpty else {
            print("Error: User ID is empty")
            return
        }
        
        let db = Firestore.firestore()
        let data = [
            "timeManagementExperience": responses.timeManagementExperience ?? "",
            "topPriority": responses.topPriority ?? "",
            "quote": responses.goal ?? "",
            "mission": responses.goal ?? "",
            "notificationFrequency": responses.usageFrequency ?? "",
            "notificationTime": responses.notificationTime ?? "",
            "notificationDays": responses.notificationDays,
            "interestedFeatures": responses.interestedFeatures,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        print("Attempting to save data for user \(userId):")
        print(data)
        
        db.collection("users").document(userId).setData(data, merge: true) { error in
            if let error = error {
                print("Firebase save error: \(error.localizedDescription)")
            } else {
                print("Survey responses successfully saved for user \(userId)")
            }
        }
    }
}
