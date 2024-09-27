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
    
    @State private var initialBalance = 0.0
    @State private var contributionAmount = 0.0
    @State private var interestRate = 7.0
    @State private var numberOfYears = 10
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
                    TextField("Initial Balance", value: $initialBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                }
                Section("Contributions") {
                    VStack{
                        TextField("Initial Balance", value: $contributionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
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
                        Slider(value: $interestRate, in: 0...25, step:0.5)
                            .frame(maxWidth: 260)
                        Spacer()
                        Text("\(interestRate.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", interestRate) : String(format: "%.1f", interestRate))%")
                    }
                    HStack{
                        Text("Compounds ")
                        Picker("Compounds", selection: $compoundingPeriodText) {
                            ForEach(compoundingPeriodOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                Picker("Years of Growth", selection: $numberOfYears) {
                    ForEach(0..<80) {
                        Text("\($0) years")
                    }
                }
                Section("Future value"){
                    Text(calculateCompoundInterest(initialBalance: initialBalance, monthlyContribution: monthlyContributionAmount, annualInterestRate: interestRate/100, years: Double(numberOfYears), compoundingPeriodsPerYear: numberCompoundingPeriods), format: .currency(code: "USD"))
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
}

func calculateCompoundInterest(initialBalance: Double, monthlyContribution: Double, annualInterestRate: Double, years: Double, compoundingPeriodsPerYear: Double = 12) -> Double {
    print("monthlyContribution: \(monthlyContribution)")
    print("compounding periods: \(compoundingPeriodsPerYear)")
    // Convert annual interest rate to a decimal
    let ratePerPeriod = annualInterestRate / compoundingPeriodsPerYear
    
    // Calculate the total number of compounding periods
    let totalPeriods = compoundingPeriodsPerYear * years
    
    // Calculate future value of the initial balance
    let futureValueOfInitialBalance = initialBalance * pow(1 + ratePerPeriod, totalPeriods)
    
    // Calculate future value of monthly contributions
    let futureValueOfContributions = monthlyContribution * (pow(1 + ratePerPeriod, totalPeriods) - 1) / ratePerPeriod
    
    // Sum of both to get the final future value
    let futureValue = futureValueOfInitialBalance + futureValueOfContributions
    
    return futureValue
}

#Preview {
    CompundInterestCalculator()
}
