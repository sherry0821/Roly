//
//  SettingsRowView.swift
//  Roly
//
//  Created by 劉采璇 on 3/11/25.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: imageName)
                .imageScale(.small)
                .aspectRatio(contentMode: .fit)
                .frame(width: 21)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.rolyMainPink)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(tintColor)
        }
        .frame(height: 50)
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: .rolyMainPink)
}
