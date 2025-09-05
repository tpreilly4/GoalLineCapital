//
//  DollarAmountTextField.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/4/24.
//

import SwiftUI

struct DollarAmountTextField: View {
    @Binding var amount: String
    
    var placeholderText = "Amount"
    var includeCents = true
    
    @FocusState private var amountIsFocused: Bool
    
    var body: some View {
        VStack{
            HStack{
                Text("$")
                TextField(placeholderText, text: $amount)
                    .easyDollarInput(with: $amount)
                    .focused($amountIsFocused)
                if !amount.isEmpty {
                    Button {
                        amount = ""
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onChange(of: amountIsFocused) {
                if !amountIsFocused {
                    // Clean up the input when focus is lost
                    let cleanedAmount = amount.replacingOccurrences(of: ",", with: "")
                    self.amount = formatDollarAmount(amount: cleanedAmount, includeCents: includeCents) ?? amount
                }
            }
        }
        .toolbar {
            if amountIsFocused {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            amountIsFocused = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
        }
    }
}
