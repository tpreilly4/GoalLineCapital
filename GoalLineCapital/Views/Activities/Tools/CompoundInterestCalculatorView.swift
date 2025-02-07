//
//  CompoundInterestCalculatorView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI
import Foundation

struct CompoundInterestCalculatorView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var initialBalanceString = ""
    var initialBalance: Double {
        initialBalanceString.toDoubleAmount
    }
    
    @State private var contributionAmountString = ""
    var contributionAmount: Double {
        contributionAmountString.toDoubleAmount
    }
    
    @State private var interestRate = 0.1
    @State private var numberOfYears = 10.0
    @State private var compoundingRate = TimeRangeUnit.monthly
    @State private var contributionRate = TimeRangeUnit.monthly
        
    var body: some View {
        NavigationStack {
            Form {
                ListStartBrandingView()
                
                Section("Current Balance") {
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
                
                Section {
                    PercentSlider(value: $interestRate, range: 0...0.25, step:0.005)
                } header: {
                    Text("Estimated Interest Rate")
                } footer: {
                    Text("The average return of the S&P 500 over the last 30 years is roughly 10%")
                        .italic()
                }
                
                Section {
                    HStack {
                        Slider(value: $numberOfYears, in: 0...80, step:1)
                            .frame(maxWidth: 250)
                        Spacer()
                        Text("\(String(Int(numberOfYears))) years")
                    }
                } header: {
                    Text("Compounds For")
                } footer: {
                    Text("Calculator assumes monthly compounding periods")
                        .italic()
                }

                Section(){
                    DollarOutputView(title: "Future Value:", value: calculateCompoundInterest())
                }
                ListEndBrandingView()
            }
            .navigationTitle("Compound Interest Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(BrandingGradients().brandingGradient)
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
    CompoundInterestCalculatorView()
}
