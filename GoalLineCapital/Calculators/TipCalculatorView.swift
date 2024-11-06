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
    @State private var tipPercentage = 20.0
    @State private var checkIsSplit = false
    
    var billAmount: Double {
        if checkAmountString.isEmpty { return 0.0 }
        if let decimalAmount = Double(checkAmountString) {
            return decimalAmount
        } else {
            print("Error converting check amount to Double")
            return 0.0
        }
    }
    
    var tipAmount: Double {
        return billAmount * (tipPercentage/100)
    }
    
    var totalBill: Double {
        return billAmount + tipAmount
    }
    
    var totalPerPerson: Double {
        return totalBill / Double(numberOfPeople)
    }
    
    var body: some View {
        NavigationStack{
            Form {
                
                Section(header: Text("Bill Amount").font(.headline).foregroundStyle(.tint)){
                    DollarAmountTextField(amount: $checkAmountString, placeholderText: "Bill amount")
                }
                
                Section(header: Text("Tip Amount").font(.headline).foregroundStyle(.tint)) {
                    HStack{
                        Slider(value: $tipPercentage, in: 0...100, step: 5.0)
                        Spacer()
                        Text("\(tipPercentage.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", tipPercentage) : String(format: "%.1f", tipPercentage))%")
                    }
                }
                
                Section{
                    HStack{
                        Text("Tip amount:")
                        Spacer()
                        if tipPercentage == 0 {
                            Text("😢")
                        }
                        Text(tipAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
                    HStack{
                        Text("Total with tip:")
                        Spacer()
                        Text(totalBill, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.tint)
                    }
                }
                
                Section(header: Text("Splitting it with others?").font(.headline).foregroundStyle(.tint))
                {
                    Picker("", selection: $checkIsSplit) {
                        ForEach([false, true], id:\.self) {
                            Text($0 == true ? "Yes" : "No")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Section{
                        if checkIsSplit {
                            Picker("How many people?", selection: $numberOfPeople) {
                                ForEach(2..<26) { num in
                                    Text("\(num) people")
                                        .tag(num)
                                }
                            }
                            .pickerStyle(.menu)
                            HStack{
                                Text("Total per person:")
                                Spacer()
                                Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .foregroundStyle(.tint)
                            }
                        }
                    }.transition(.slide)
                }
                ListEndBrandingView()
            }
            .animation(.easeInOut, value: checkIsSplit)
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
