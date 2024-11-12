//
//  CompundInterestCalculator.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI
import Foundation

struct CompundInterestCalculator: View {
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
    @State private var compoundingPeriodText = "Monthly"
    @State private var contributionRateText = "Monthly"
    
    let compoundingPeriodOptions = ["Daily", "Monthly", "Yearly"]
    let contributionRateOptions = ["Daily", "Weekly", "Monthly", "Yearly"]
    
    var numberCompoundingPeriods: Double {
        if compoundingPeriodText == "Daily" {
            return 365
        } else if compoundingPeriodText == "Monthly" {
            return 12
        } else if compoundingPeriodText == "Yearly" {
            return 1
        } else {
            return 0
        }
    }
    
    var monthlyContributionAmount: Double {
        switch contributionRateText {
        case "Daily":
            return contributionAmount * 365 / 12
        case "Monthly":
            return contributionAmount
        case "Weekly":
            return contributionAmount * 52 / 12
        case "Yearly":
            return contributionAmount / 12
        default:
            return 0.0
        }
    }
        
    var body: some View {
        NavigationStack {
            Form {
                Section("Initial Balance") {
                    DollarAmountTextField(amount: $initialBalanceString, placeholderText: "Enter current balance", includeCents: false)
                }
                Section("Contributions") {
                    VStack{
                        DollarAmountTextField(amount: $contributionAmountString, placeholderText: "Enter contributions", includeCents: false)
                        Picker("Rate", selection: $contributionRateText) {
                            ForEach(contributionRateOptions, id: \.self) {
                                Text($0)
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
                        Picker("", selection: $compoundingPeriodText) {
                            ForEach(compoundingPeriodOptions, id: \.self) {
                                Text($0)
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
        let annualInterestRate = interestRate
        // Convert annual interest rate to a decimal
        let ratePerPeriod = annualInterestRate / numberCompoundingPeriods
        
        // Calculate the total number of compounding periods
        let totalPeriods = numberCompoundingPeriods * Double(numberOfYears)
        
        // Calculate future value of the initial balance
        let futureValueOfInitialBalance = initialBalance * pow(1 + ratePerPeriod, totalPeriods)
        
        // Calculate future value of monthly contributions
        let futureValueOfContributions = monthlyContributionAmount * (pow(1 + ratePerPeriod, totalPeriods) - 1) / ratePerPeriod
        
        // Sum of both to get the final future value
        let futureValue = futureValueOfInitialBalance + futureValueOfContributions
        
        return futureValue
    }
}



#Preview {
    CompundInterestCalculator()
}
