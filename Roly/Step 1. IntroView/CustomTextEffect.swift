//
//  CustomTextEffect.swift
//  Roly
//
//  Created by 劉采璇 on 3/13/25.
//

import SwiftUI

struct TitleTextRenderer: TextRenderer, Animatable {
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let slices = layout.flatMap({ $0 }).flatMap({ $0 })
        
        for (index, slice) in slices.enumerated() {
            let sliceProgressIndex = CGFloat(slices.count) * progress
            let sliceProgress = max(min(sliceProgressIndex / CGFloat(index + 1), 1), 0)
            
            // If you want each slice to begin from its origin point, create a copy context
            // "var copy = context."
            // However, I want the context to be incremented after each loop, so I'm using the context directly without copying!
            // 理解 GraphicsContext 的状态管理及其对渲染的影响：複製＆累積
            ctx.addFilter(.blur(radius: 5 - (5 * sliceProgress)))
            ctx.opacity = sliceProgress
            ctx.translateBy(x: 0, y: 5 - (5 * sliceProgress))
            ctx.draw(slice, options: .disablesSubpixelQuantization)
            
        }
    }
}
