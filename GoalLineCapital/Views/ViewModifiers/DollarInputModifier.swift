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
                // Format input in real-time with commas while being smart about cursor preservation
                let formattedValue = formatInputWithCommas(newValue, oldValue: oldValue)
                
                // Only update if formatting is needed and safe
                if formattedValue != newValue && shouldApplyFormatting(oldValue: oldValue, newValue: newValue, formattedValue: formattedValue) {
                    DispatchQueue.main.async {
                        amount = formattedValue
                    }
                }
            }
            .keyboardType(.decimalPad)
            .submitLabel(.done)
    }
    
    private func shouldApplyFormatting(oldValue: String, newValue: String, formattedValue: String) -> Bool {
        // Extract just the numeric content for comparison
        let oldDigits = oldValue.filter { $0.isNumber }
        let newDigits = newValue.filter { $0.isNumber }
        
        // Always allow formatting when adding digits
        if newDigits.count >= oldDigits.count {
            return true
        }
        
        // For deletions, be very conservative
        // Only apply formatting if we're sure it won't disrupt cursor position
        
        // Case 1: Check if deletion happened at the end (safest)
        let oldClean = oldValue.replacingOccurrences(of: ",", with: "")
        let newClean = newValue.replacingOccurrences(of: ",", with: "")
        
        if oldClean.hasPrefix(newClean) {
            // Deletion from the end - safe to format
            return true
        }
        
        // Case 2: Check if the user is trying to delete a comma
        // If the input appears to be removing only commas, we should reformat
        if oldValue.replacingOccurrences(of: ",", with: "") == newValue.replacingOccurrences(of: ",", with: "") {
            return true
        }
        
        // Case 3: For any other deletion (likely from middle), don't reformat immediately
        // This preserves cursor position for middle editing
        return false
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
        
        // Check if this is a deletion operation by comparing digit counts
        let oldDigits = oldValue.filter { $0.isNumber }
        let newDigits = digitsAndDecimal.filter { $0.isNumber }
        let isDeletion = newDigits.count < oldDigits.count
        
        // For deletions, be more conservative to preserve cursor position
        if isDeletion {
            // Only reformat if the result would be significantly different
            // This helps maintain cursor position during backspace operations
            let currentFormatted = addCommasToDigits(digitsAndDecimal)
            
            // If the input already has the right format, return it as-is
            if input == currentFormatted {
                return input
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
    
    private func addCommasToDigits(_ input: String) -> String {
        let components = input.components(separatedBy: ".")
        let integerPart = components[0]
        let decimalPart = components.count > 1 ? components[1] : nil
        
        let formattedInteger = addCommasToInteger(integerPart)
        
        if let decimal = decimalPart {
            return "\(formattedInteger).\(decimal)"
        } else if input.hasSuffix(".") {
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
