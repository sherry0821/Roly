//
//  TestView.swift
//  Roly
//
//  Created by 劉采璇 on 3/12/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        Text("Hello, World!")
            .font(.custom("Aclonica-Regular", size: 20))
            .onAppear {
                print("View appeared")
                for family in UIFont.familyNames {
                    print(family)
                    for name in UIFont.fontNames(forFamilyName: family) {
                        print("  \(name)")
                    }
                }
            }
    }
}

#Preview {
    TestView()
}
