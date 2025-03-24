//
//  PositionButtonView.swift
//  Roly
//
//  Created by 劉采璇 on 3/3/25.
//

import SwiftUI

struct PositionButtonView: View {
    @Binding var selectedPosition: Int
    
    let isDisabled: Bool

    var body: some View {
        Button(action: {
            selectedPosition = (selectedPosition + 1) % 3
//            selectedPosition = (selectedPosition % 3) + 1 // Cycles 1, 2, 3
        }) {
            VStack(spacing: 3) { // 調整 spacing 以適配 50px
                FrameView(isSelected: selectedPosition == 0, frameIndex: 0)
                FrameView(isSelected: selectedPosition == 1, frameIndex: 1)
                FrameView(isSelected: selectedPosition == 2, frameIndex: 2)
            }
            .padding(4) // 調整 padding 以適配 50px
            .frame(width: 50, height: 50)
            .background(RoundedRectangle(cornerRadius: 8).fill(.rolyMainPink))
        }
        .disabled(isDisabled)
    }
}

struct FrameView: View {
    let isSelected: Bool
    let frameIndex: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(
                    width: frameWidth,
                    height: frameHeight
                )
                .foregroundColor(isSelected ? .white : .clear)
                .border(Color.white, width: 1)
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.rolyMainPink)
                    .font(.system(size: 9, weight: .black))
            }
        }
    }
    
    private var frameWidth: CGFloat {
        if frameIndex == 0 {
            return 34
        }
        return isSelected ? 16 : 12
    }
    
    private var frameHeight: CGFloat {
        if frameIndex == 0 {
            return isSelected ? 12 : 8
        }
        return isSelected ? 16 : 12
    }
}

struct PositionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PositionButtonView(selectedPosition: .constant(0), isDisabled: false)
            .previewLayout(.fixed(width: 50, height: 50))
    }
}
