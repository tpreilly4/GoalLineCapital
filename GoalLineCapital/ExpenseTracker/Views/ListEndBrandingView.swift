//
//  ListEndBranding.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

struct ListEndBrandingView: View {
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Image("GLC-icon").resizable().scaledToFit().frame(maxWidth: 75)
                    .listRowBackground(Color.clear)
                Spacer()
            }
            .padding(.vertical)
            HStack{
                Spacer()
                Text("Copyright 2024. Goal Line Capital.")
                    .font(.system(size: 12))
                Spacer()
            }
            .padding(.bottom)
        }
        .listRowBackground(Color.clear)
    }
}

#Preview {
    ListEndBrandingView()
}
