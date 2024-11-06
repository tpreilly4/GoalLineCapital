//
//  TipCalculatorView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct TipCalculatorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var checkAmountString = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
        
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var checkAmount: Double {
        if checkAmountString.isEmpty { return 0.0 }
        if let decimalAmount = Double(checkAmountString) {
            return decimalAmount
        } else {
            print("Error converting check amount to Double")
            return 0.0
        }
    }
    
    var totalCheck: Double {
        let tipValue = checkAmount / 100 * Double(tipPercentage)
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    var totalPerPerson: Double {
        let tipValue = checkAmount / 100 * Double(tipPercentage)
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / Double(numberOfPeople + 2)

        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section("Amount"){
                    DollarAmountTextField(amount: $checkAmountString)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("How much tip do you want to leave?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                }
                .pickerStyle(.segmented)
                Section("Total check with tip"){
                    Text(totalCheck, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundColor(tipPercentage == 0 ? .red : .black)
                }
                Section("Amount owed per person is..."){
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                ListEndBrandingView()
            }
            .navigationTitle("Tip Calculator")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TipCalculatorView()
}
