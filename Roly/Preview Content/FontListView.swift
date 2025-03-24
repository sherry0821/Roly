//
//  FontListView.swift
//  Roly
//
//  Created by 劉采璇 on 3/10/25.
//

import SwiftUI

struct FontListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(UIFont.familyNames.sorted(), id: \.self) { family in
                    Text(family).font(.title).padding(.top)
                    ForEach(UIFont.fontNames(forFamilyName: family), id: \.self) { fontName in
                        Text(fontName).font(.custom(fontName, size: 16))
                    }
                }
            }
            .padding()
        }
    }
}

struct FontListView_Previews: PreviewProvider {
    static var previews: some View {
        FontListView()
    }
}
