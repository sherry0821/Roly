//
//  DropViewDelegate.swift
//  Roly
//
//  Created by 劉采璇 on 3/17/25.
//

import SwiftUI

struct DropViewDelegate: DropDelegate {
    let destinationItem: String
    @Binding var objectives: [String]
    @Binding var draggedItem: String?
    
    func dropUpdated(info: DropInfo) -> DropProposal {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedItem {
            let fromIndex = objectives.firstIndex(of: draggedItem)
            if let fromIndex {
                let toIndex = objectives.firstIndex(of: destinationItem)
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.objectives.move(fromOffsets: IndexSet(integer: fromIndex), toOffset:
                                         (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}
