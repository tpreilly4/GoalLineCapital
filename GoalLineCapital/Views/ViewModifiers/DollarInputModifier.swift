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
                // Format input in real-time with commas
                let formattedValue = formatInputWithCommas(newValue, oldValue: oldValue)
                
                // Only update if the formatted value is different to avoid infinite loops
                if formattedValue != newValue {
                    amount = formattedValue
                }
            }
            .keyboardType(.decimalPad)
            .submitLabel(.done)
    }
    
    private func formatInputWithCommas(_ input: String, oldValue: String) -> String {
        // Remove all non-digit, non-decimal characters first
        let digitsAndDecimal = input.filter { $0.isNumber || $0 == "." }
        
        // Basic validation: reject invalid input
        let allowedChars = CharacterSet(charactersIn: "0123456789.")
        let inputChars = CharacterSet(charactersIn: digitsAndDecimal)
        
        if !allowedChars.isSuperset(of: inputChars) {
            return oldValue
        }
        
        // Prevent multiple decimal points
        let decimalCount = digitsAndDecimal.filter { $0 == "." }.count
        if decimalCount > 1 {
            return oldValue
        }
        
        // Prevent more than 2 digits after decimal
        if let decimalIndex = digitsAndDecimal.lastIndex(of: ".") {
            let afterDecimal = String(digitsAndDecimal[digitsAndDecimal.index(after: decimalIndex)...])
            if afterDecimal.count > 2 {
                return oldValue
            }
        }
        
        // Split on decimal point
        let components = digitsAndDecimal.components(separatedBy: ".")
        let integerPart = components[0]
        let decimalPart = components.count > 1 ? components[1] : nil
        
        // Format the integer part with commas if it has 4+ digits
        let formattedInteger = addCommasToInteger(integerPart)
        
        // Combine integer and decimal parts
        if let decimal = decimalPart {
            return "\(formattedInteger).\(decimal)"
        } else if digitsAndDecimal.hasSuffix(".") {
            return "\(formattedInteger)."
        } else {
            return formattedInteger
        }
    }
    
    private func addCommasToInteger(_ integerString: String) -> String {
        // Only add commas if we have 4 or more digits
        guard integerString.count >= 4 else {
            return integerString
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        
        if let number = Int(integerString),
           let formatted = formatter.string(from: NSNumber(value: number)) {
            return formatted
        }
        
        return integerString
    }
}

extension View {
    func easyDollarInput(with amount: Binding<String>) -> some View {
        modifier(DollarInputModifier(amount: amount))
    }
}
