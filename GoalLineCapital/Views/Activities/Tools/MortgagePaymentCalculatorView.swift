//
//  MortgagePaymentCalculatorView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

struct MortgagePaymentCalculatorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var includeTaxesAndFees = false
    @State private var loanTermYears = 30
    @State private var interestRate = 0.05
    
    @State private var homePriceString = ""
    var homePrice: Double {
        homePriceString.toDoubleAmount
    }

    @State private var downPaymentAmountString = ""
    var downPaymentAmount: Double {
        downPaymentAmountString.toDoubleAmount
    }

    @State private var propertyTaxString = ""
    var propertyTax: Double {
        propertyTaxString.toDoubleAmount
    }
    @State private var propertyTaxTerm = TimeRangeUnit.yearly

    @State private var homeInsuranceString = ""
    var homeInsurance: Double {
        homeInsuranceString.toDoubleAmount
    }
    @State private var homeInsuranceTerm = TimeRangeUnit.yearly

    @State private var pmiAmountString = ""
    var pmiAmount: Double {
        pmiAmountString.toDoubleAmount
    }
    @State private var pmiTerm = TimeRangeUnit.monthly

    @State private var hoaAmountString = ""
    var hoaAmount: Double {
        hoaAmountString.toDoubleAmount
    }
    @State private var hoaFeesTerm = TimeRangeUnit.monthly
    
    var estimatedMonthlyPayment : Double {
        return calculateMonthlyPayment()
    }
    
    let loanTermOptions = [15, 20, 30]
    
    var body: some View {
        NavigationStack {
            Form {
                ListStartBrandingView()
                
                Section(header: Text("Home Price")) {
                    HStack {
                        DollarAmountTextField(amount: $homePriceString, placeholderText: "Enter home price", includeCents: false)
                    }
                }
                
                Section("Down Payment") {
                    DollarAmountTextField(amount: $downPaymentAmountString, placeholderText: "Enter down payment", includeCents: false)
                    HStack {
                        Button("5%") { autofillDownPayment(percentage: 0.05) }.layoutPriority(1).buttonStyle(.borderless)
                        Spacer()
                        Button("10%") { autofillDownPayment(percentage: 0.10) }.layoutPriority(1).buttonStyle(.borderless)
                        Spacer()
                        Button("15%") { autofillDownPayment(percentage: 0.15) }.layoutPriority(1).buttonStyle(.borderless)
                        Spacer()
                        Button("20%") { autofillDownPayment(percentage: 0.2) }.layoutPriority(1).buttonStyle(.borderless)
                    }.disabled(homePriceString.isEmpty)
                }
                
                Section ("Interest rate") {
                    PercentSlider(value: $interestRate, range: 0...0.10, step:0.0001)
                    HStack {
                        Text("Loan term (years):")
                        Picker("Term", selection: $loanTermYears) {
                            ForEach(loanTermOptions, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section(header: Text("Include Taxes and Fees?").font(.headline).foregroundStyle(.tint))
                {
                    YesNoPicker(selection: $includeTaxesAndFees)
                }
                
                if includeTaxesAndFees {
                    
                    Section("Property Tax") {
                        DollarAmountTextField(amount: $propertyTaxString, placeholderText: "Enter property tax", includeCents: false)
                        Picker("Term", selection: $propertyTaxTerm) {
                            ForEach([TimeRangeUnit.monthly, TimeRangeUnit.quarterly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Home Insurance") {
                        DollarAmountTextField(amount: $homeInsuranceString, placeholderText: "Enter home insurance", includeCents: false)
                        Picker("Term", selection: $homeInsuranceTerm) {
                            ForEach([TimeRangeUnit.monthly, TimeRangeUnit.quarterly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("PMI") {
                        DollarAmountTextField(amount: $pmiAmountString, placeholderText: "Enter PMI", includeCents: false)
                        Picker("Term", selection: $pmiTerm) {
                            ForEach([TimeRangeUnit.monthly, TimeRangeUnit.quarterly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("HOA Fees") {
                        DollarAmountTextField(amount: $hoaAmountString, placeholderText: "Enter HOA fees", includeCents: false)
                        Picker("Term", selection: $hoaFeesTerm) {
                            ForEach([TimeRangeUnit.monthly, TimeRangeUnit.quarterly, TimeRangeUnit.yearly], id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section() {
                    DollarOutputView(title:"Estimated Monthly Payment:", value: calculateMonthlyPayment())
                }
                
                ListEndBrandingView()
                    .transition(.slide)
            }
            .navigationTitle("Mortgage Estimator")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.easeInOut, value: includeTaxesAndFees)
            .scrollContentBackground(.hidden)
            .background(BrandingGradients().brandingGradient)
        }
    }
    
    private func calculateMonthlyPayment() -> Double {
        var payment = 0.0
        let loanAmount = homePrice - downPaymentAmount
        let monthlyRate = interestRate / 12
        let totalPayments = loanTermYears * 12
        
        // Check if interest rate is zero to avoid division by zero
        if monthlyRate == 0 {
            payment = loanAmount / Double(totalPayments)
        } else {
            payment = loanAmount * (monthlyRate * pow(1 + monthlyRate, Double(totalPayments))) / (pow(1 + monthlyRate, Double(totalPayments)) - 1)
        }
        
        if includeTaxesAndFees {
            // Add additional expenses (Property Tax, PMI, and HOA) if applicable
            let monthlyPropertyTax = propertyTax / propertyTaxTerm.monthsPerUnit
            let monthlyHomeInsurance = homeInsurance / homeInsuranceTerm.monthsPerUnit
            let monthlyPmi = pmiAmount / pmiTerm.monthsPerUnit
            let monthlyHoa = hoaAmount / hoaFeesTerm.monthsPerUnit
            payment += monthlyPropertyTax + monthlyHomeInsurance + monthlyPmi + monthlyHoa
        }
        
        return payment
    }
    
    private func autofillDownPayment(percentage: Double) {
        downPaymentAmountString = String(Int(homePrice * percentage))
    }
}

#Preview {
    MortgagePaymentCalculatorView()
}
