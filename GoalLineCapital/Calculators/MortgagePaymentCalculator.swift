//
//  MortgagePaymentCalculator.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

struct MortgagePaymentCalculator: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var homePrice = 300000.00
    @State private var downPaymentAmount = 60000.00
    //@State private var downPaymentPercentage = 0.2
    @State private var loanTermYears = 30
    @State private var interestRate = 3.0
    @State private var propertyTax = 0.0
    @State private var homeInsurance = 0.0
    @State private var pmiAmount = 0.0
    @State private var hoaAmount = 0.0
    
    var estimatedMonthlyPayment : Double {
        return calculateMonthlyPayment()
    }
    
    let loanTermOptions = [15, 20, 30]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mortgage Details")) {
                    HStack {
                        Text("Home Price")
                        Spacer()
                        TextField("Enter Home Price", value: $homePrice, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                    HStack {
                        Text("Down Payment Amount")
                        Spacer()
                        TextField("Enter Down Payment", value: $downPaymentAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                }
                Section ("Interest rate") {
                    HStack{
                        Slider(value: $interestRate, in: 0...10, step:0.1)
                            .frame(maxWidth: 260)
                        Spacer()
                        Text("\(interestRate.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", interestRate) : String(format: "%.1f", interestRate))%")
                    }
                }
                Section("Loan Term (Years") {
                    Picker("Term", selection: $loanTermYears) {
                        ForEach(loanTermOptions, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                }
                
                Section(header: Text("Additional Expenses")) {
                    HStack {
                        Text("Property Tax (Yearly)")
                        Spacer()
                        TextField("Enter Property Tax", value: $propertyTax, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                    HStack {
                        Text("Home Insurance (Yearly)")
                        Spacer()
                        TextField("Enter Home Insurance", value: $homeInsurance, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                    HStack {
                        Text("PMI (Monthly)")
                        Spacer()
                        TextField("Enter PMI", value: $pmiAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                    HStack {
                        Text("HOA Fees (Monthly)")
                        Spacer()
                        TextField("Enter HOA Fees", value: $hoaAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 150)
                    }
                }
                Section(header: Text("Estimated Monthly Payment")) {
                    Text("$\(calculateMonthlyPayment(), specifier: "%.2f")")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                ListEndBrandingView()
            }
            .navigationTitle("Mortgage Payment Estimator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mortgage Payment Estimator").font(.headline)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func calculateMonthlyPayment() -> Double {
        print("Hello")
        var payment = 0.0
        let loanAmount = homePrice - downPaymentAmount
        let monthlyRate = (interestRate/100) / 12
        let totalPayments = loanTermYears * 12
        
        // Check if interest rate is zero to avoid division by zero
        if monthlyRate == 0 {
            payment = loanAmount / Double(totalPayments)
        } else {
            payment = loanAmount * (monthlyRate * pow(1 + monthlyRate, Double(totalPayments))) / (pow(1 + monthlyRate, Double(totalPayments)) - 1)
        }
        
        // Add additional expenses (Property Tax, PMI, and HOA) if applicable
        let monthlyPropertyTax = propertyTax / 12
        let monthlyHomeInsurance = homeInsurance / 12
        payment += monthlyPropertyTax + monthlyHomeInsurance + pmiAmount + hoaAmount
        return payment
    }
}

#Preview {
    MortgagePaymentCalculator()
}
