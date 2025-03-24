//
//  InputView.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

import SwiftUI

struct IconModifier {
    var scale: CGFloat = 1.0
    var rotationAngle: Double = 0.0
}

struct InputView: View {
    @Binding var text: String
//    let title: String
    let placeholder: String
    var isSecureField = false
    let icon: String
    var customIconModifier: IconModifier? = nil/*AnyView = AnyView(EmptyView())*/ // Default to an empty view if no modifier
    var customIconColor: Color? = nil
    var isDisabled: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 273, height: 60)
                .foregroundColor(.white)
                .opacity(0.4)
            HStack(spacing: 20) {
                Circle()
                    .foregroundColor(.rolyMainPink)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .modifier(CustomIconModifier(iconModifier: customIconModifier)) // Apply customIconModifier if provided
                    )
                    .padding(.leading, 5)
                
                if isSecureField {
                    SecureField("", text: $text)
                        .foregroundColor(colorScheme == .light ? .rolyMainPink : .white)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                        .overlay(
                            // 自訂佔位文字
                            Text(placeholder)
                                .font(.callout)
                                .foregroundColor(colorScheme == .light ? .rolyMainPink : .white) // 動態設置顏色
                                .opacity(text.isEmpty ? 0.4 : 0), // 只有當輸入框為空時顯示
                            alignment: .leading
                        )
                } else {
                    TextField("", text: $text)
                        .foregroundColor(colorScheme == .light ? .rolyMainPink : .black)
                        .font(.system(size: 14))
                        .autocapitalization(.none)
                        .overlay(
                            // 自訂佔位文字
                            Text(placeholder)
                                .font(.callout)
                                .foregroundColor(colorScheme == .light ? .rolyMainPink : .white) // 動態設置顏色
                                .opacity(text.isEmpty ? 0.4 : 0), // 只有當輸入框為空時顯示
                            alignment: .leading
                        )
                }
            }
        }
    }
}

// Define IconModifier to apply rotation and scale
struct CustomIconModifier: ViewModifier {
    let iconModifier: IconModifier?
    
    func body(content: Content) -> some View {
        if let modifier = iconModifier {
            content
                .scaleEffect(modifier.scale)
                .rotationEffect(Angle(degrees: modifier.rotationAngle))
        } else {
            content
        }
    }
}


#Preview {
    InputView(text: .constant(""), placeholder: "name@example.com", icon: "star")
}
