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
                // More permissive validation during editing
                // Allow partial states that occur during backspace/editing
                let allowedChars = CharacterSet(charactersIn: "0123456789.,")
                let inputChars = CharacterSet(charactersIn: newValue)
                
                // Basic validation: only allow digits, commas, and decimal points
                if !allowedChars.isSuperset(of: inputChars) {
                    amount = oldValue
                    return
                }
                
                // Prevent multiple decimal points
                let decimalCount = newValue.filter { $0 == "." }.count
                if decimalCount > 1 {
                    amount = oldValue
                    return
                }
                
                // Prevent more than 2 digits after decimal
                if let decimalIndex = newValue.lastIndex(of: ".") {
                    let afterDecimal = String(newValue[newValue.index(after: decimalIndex)...])
                    if afterDecimal.count > 2 {
                        amount = oldValue
                        return
                    }
                }
                
                // Allow the change - we'll validate properly formatted state on focus loss
                print("Allowing intermediate input: \(newValue)")
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
