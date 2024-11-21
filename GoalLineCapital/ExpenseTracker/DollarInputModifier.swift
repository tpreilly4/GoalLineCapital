//
//  DollarInputModifier.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/20/24.
//

import Foundation
import SwiftUI

struct DollarInputModifier: ViewModifier {
    @Binding var amount: String
    @FocusState var focus: Bool

    func body(content: Content) -> some View {
        content
            .onChange(of: amount) { oldValue, newValue in
                let regex = #"^\d*\.?\d{0,2}$"#

                if let _ = newValue.range(of: regex, options: .regularExpression) {
                    print("Valid string for currency")
                } else {
                    amount = oldValue
                }
            }
            .keyboardType(.decimalPad)
            .submitLabel(.done)
    }
}

extension View {
    func easyDollarInput(with amount: Binding<String>) -> some View {
        modifier(DollarInputModifier(amount: amount))
    }
}
