//
//  Card.swift
//  Roly
//
//  Created by 劉采璇 on 3/12/25.
//

import Foundation
import SwiftUI

struct Card: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: String
    var note: String?
}

let cards: [Card] = [
    .init(image: "pic 1", note: "2 Tasks a Day  \nEndless Possibilities."),
    .init(image: "pic 2", note: "Quantify Goals \nFind balance."),
    .init(image: "pic 3", note: "Track often    \nIntegrate Effectively."),
    .init(image: "pic 4", note: "Simplify Life  \nAmplify Success."),
    .init(image: "pic 5", note: "Feel Time      \nAchieve Naturally.")
]
