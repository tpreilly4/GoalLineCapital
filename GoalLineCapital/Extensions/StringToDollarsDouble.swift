//
//  StringToDollarsDouble.swift
//  GoalLineCapital
//
//  Quick extension that converts Strings to Doubles
//  for ease of use with DollarAmountTextField
//
//  Created by Tom Reilly on 11/7/24.
//

import Foundation

extension String {
    var toDoubleAmount: Double {
        if self.isEmpty {
            return 0.0
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        
        if let decimalAmount = formatter.number(from: self)?.doubleValue {
            return decimalAmount
        } else {
            print("Error converting string to Double")
            return 0.0
        }
    }
}

func formatDollarAmount(amount: String, includeCents: Bool) -> String? {
    // Try to convert the string to a Double
    if let doubleValue = Double(amount) {
        // Format the double value to always have 2 decimal places
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = includeCents ? 2 : 0
        formatter.maximumFractionDigits = includeCents ? 2 : 0
        
        // Return the formatted string
        return formatter.string(from: NSNumber(value: doubleValue))
    } else {
        // Return nil if the input string couldn't be converted to a Double
        return nil
    }
}
