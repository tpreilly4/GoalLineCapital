//
//  DollarAmountTextField.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/4/24.
//

import SwiftUI

struct DollarAmountTextField: View {
    @Binding var amount: String
    @FocusState private var amountIsFocused: Bool
    var body: some View {
        HStack{
            Text("$")
            TextField("Amount", text: $amount)
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
                .focused($amountIsFocused)
        }
        .onChange(of: amountIsFocused) {
            self.amount = formatDollarAmount(amount) ?? amount
        }
    }
    
    func formatDollarAmount(_ amount: String) -> String? {
        // Try to convert the string to a Double
        if let doubleValue = Double(amount) {
            // Format the double value to always have 2 decimal places
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.usesGroupingSeparator = false
            
            // Return the formatted string
            return formatter.string(from: NSNumber(value: doubleValue))
        } else {
            // Return nil if the input string couldn't be converted to a Double
            return nil
        }
    }
}
