//
//  CompundInterestCalculatorView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI
import Foundation

struct CompundInterestCalculatorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var initialBalanceString = ""
    var initialBalance: Double {
        initialBalanceString.toDoubleAmount
    }
    
    @State private var contributionAmountString = ""
    var contributionAmount: Double {
        contributionAmountString.toDoubleAmount
    }
    
    @State private var interestRate = 0.07
    @State private var numberOfYears = 10.0
    @State private var compoundingRate = TimeRangeUnit.monthly
    @State private var contributionRate = TimeRangeUnit.monthly
        
    var body: some View {
        NavigationStack {
            Form {
                Section("Initial Balance") {
                    DollarAmountTextField(amount: $initialBalanceString, placeholderText: "Enter current balance", includeCents: false)
                }
                Section("Contributions") {
                    VStack{
                        DollarAmountTextField(amount: $contributionAmountString, placeholderText: "Enter contributions", includeCents: false)
                        Picker("Rate", selection: $contributionRate) {
                            ForEach([TimeRangeUnit.daily, TimeRangeUnit.weekly, TimeRangeUnit.monthly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                Section("Interest"){
                    HStack{
                        PercentSlider(value: $interestRate, range: 0...0.25, step:0.005)
                    }
                    HStack{
                        Text("Compounds:")
                        Picker("", selection: $compoundingRate) {
                            ForEach([TimeRangeUnit.daily, TimeRangeUnit.monthly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                Section("Compounding For") {
                    HStack {
                        Slider(value: $numberOfYears, in: 0...80, step:1)
                            .frame(maxWidth: 250)
                        Spacer()
                        Text("\(String(Int(numberOfYears))) years")
                    }
                }

                Section(){
                    DollarOutputView(title: "Future Value:", value: calculateCompoundInterest())
                }
                ListEndBrandingView()
            }
            .navigationTitle("Compound Interest Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Compound Interest Calculator").font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func calculateCompoundInterest() -> Double {
        // Special case for zero interest rate
        if interestRate == 0 {
            let futureValueOfInitialBalance = initialBalance
            let futureValueOfContributions = contributionAmount * contributionRate.unitsPerYear * numberOfYears
            return futureValueOfInitialBalance + futureValueOfContributions
        }
        
        // Convert annual interest rate to a rate per compounding period
        let ratePerCompoundingPeriod = interestRate / compoundingRate.unitsPerYear
        
        // Calculate the total number of compounding periods
        let totalCompoundingPeriods = compoundingRate.unitsPerYear * numberOfYears
        
        // Future value of the initial balance with compounding
        let futureValueOfInitialBalance = initialBalance * pow(1 + ratePerCompoundingPeriod, totalCompoundingPeriods)
        
        // Adjust monthly contributions to match the compounding period
        let effectiveMonthlyContribution = contributionAmount * contributionRate.unitsPerYear / compoundingRate.unitsPerYear
        
        // Future value of monthly contributions with compounding
        let futureValueOfContributions = effectiveMonthlyContribution * ((pow(1 + ratePerCompoundingPeriod, totalCompoundingPeriods) - 1) / ratePerCompoundingPeriod)
        
        // Sum both components to get the total future value
        let futureValue = futureValueOfInitialBalance + futureValueOfContributions
        
        return futureValue
    }
}



#Preview {
    CompundInterestCalculatorView()
}
