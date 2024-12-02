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
                self.amount = formatDollarAmount(amount: amount, includeCents: includeCents) ?? amount
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
