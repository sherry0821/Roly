//
//  User.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let quote: String
    var email: String
    var topPriority: String?
    var mission: String?
    var strategies: [String]
    var objectives: [String]
    // Phone number, birth
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        fullname: "Cheng Han Yang",
        quote: "Life is short. Work smart and play hard.",
        email: "bingo@gmail.com",
        topPriority: "",
        mission: "",
        strategies: [],
        objectives: ["", "", "", "", "", "", "", ""]
    )
}
