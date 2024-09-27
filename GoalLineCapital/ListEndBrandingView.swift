//
//  ListEndBranding.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

struct ListEndBrandingView: View {
    var body: some View {
        HStack{
            Spacer()
            Image("GLC-icon").resizable().scaledToFit().frame(maxWidth: 75)
                .listRowBackground(Color.clear)
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    ListEndBrandingView()
}
