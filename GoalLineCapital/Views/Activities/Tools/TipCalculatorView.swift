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
    @State private var tipPercentage = 0.2
    @State private var checkIsSplit = false
    
    var billAmount: Double {
        checkAmountString.toDoubleAmount
    }
    
    var tipAmount: Double {
        return billAmount * (tipPercentage)
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
                ListStartBrandingView()
                
                Section("Bill Amount"){
                    DollarAmountTextField(amount: $checkAmountString, placeholderText: "Enter bill amount")
                }
                
                Section("Tip Percentage") {
                    PercentSlider(value: $tipPercentage, range: 0...1, step: 0.01)
                }
                
                Section{
                    if tipPercentage == 0 {
                        HStack {
                            Text("Tip amount:")
                            Spacer()
                            Text("😢")
                                .font(.title)
                                .padding([.vertical],5)
                        }
                    } else {
                        DollarOutputView(title: "Tip amount:", value: tipAmount)
                    }
                    DollarOutputView(title: "Total with tip:", value: totalBill)
                }

                Section(header: Text("Splitting it with others?").font(.headline).foregroundStyle(.tint)) {
                    YesNoPicker(selection: $checkIsSplit)
                    if checkIsSplit {
                        Picker("How many people?", selection: $numberOfPeople) {
                            ForEach(2..<21) { num in
                                Text("\(num) people")
                                    .tag(num)
                            }
                        }
                        .pickerStyle(.menu)
                        DollarOutputView(title: "Total per person:", value: totalPerPerson)
                    }
                }
                ListEndBrandingView()
            }
            .animation(.easeInOut, value: checkIsSplit)
            .navigationTitle("Tip Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(BrandingGradients().brandingGradient)
        }
    }
}

#Preview {
    TipCalculatorView()
}
