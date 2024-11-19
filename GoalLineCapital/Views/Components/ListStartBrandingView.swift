//
//  ListStartBrandingView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/19/24.
//
import SwiftUI

struct ListStartBrandingView: View {
    var body: some View {
        VStack {
            Image("GLC-logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 500)
        }
        .frame(maxHeight: 150)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    ListStartBrandingView()
}


