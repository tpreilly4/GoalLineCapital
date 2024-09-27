//
//  CardView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 3/6/24.
//

import SwiftUI

struct CardView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func cardViewWrapper() -> some View {
        modifier(CardView())
    }
}
