//
//  MortgagePaymentCalculator.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

struct MortgagePaymentCalculator: View {
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
    @State private var propertyTaxTerm = TermType.yearly

    @State private var homeInsuranceString = ""
    var homeInsurance: Double {
        homeInsuranceString.toDoubleAmount
    }
    @State private var homeInsuranceTerm = TermType.yearly

    @State private var pmiAmountString = ""
    var pmiAmount: Double {
        pmiAmountString.toDoubleAmount
    }
    @State private var pmiTerm = TermType.monthly

    @State private var hoaAmountString = ""
    var hoaAmount: Double {
        hoaAmountString.toDoubleAmount
    }
    @State private var hoaFeesTerm = TermType.monthly
    
    var estimatedMonthlyPayment : Double {
        return calculateMonthlyPayment()
    }
    
    let loanTermOptions = [15, 20, 30]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Home Price")) {
                    HStack {
                        DollarAmountTextField(amount: $homePriceString, placeholderText: "Enter home price", includeCents: false)
                    }
                }
                
                Section("Down Payment") {
                    DollarAmountTextField(amount: $downPaymentAmountString, placeholderText: "Enter down payment", includeCents: false)
                    
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
                            ForEach(TermType.allCases, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("Home Insurance") {
                        DollarAmountTextField(amount: $homeInsuranceString, placeholderText: "Enter home insurance", includeCents: false)
                        Picker("Term", selection: $homeInsuranceTerm) {
                            ForEach(TermType.allCases, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("PMI") {
                        DollarAmountTextField(amount: $pmiAmountString, placeholderText: "Enter PMI", includeCents: false)
                        Picker("Term", selection: $pmiTerm) {
                            ForEach(TermType.allCases, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Section("HOA Fees") {
                        DollarAmountTextField(amount: $hoaAmountString, placeholderText: "Enter HOA fees", includeCents: false)
                        Picker("Term", selection: $hoaFeesTerm) {
                            ForEach(TermType.allCases, id: \.self) {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .animation(.easeInOut, value: includeTaxesAndFees)
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
            let monthlyPropertyTax = propertyTax / propertyTaxTerm.divisor
            let monthlyHomeInsurance = homeInsurance / homeInsuranceTerm.divisor
            let monthlyPmi = pmiAmount / pmiTerm.divisor
            let monthlyHoa = hoaAmount / hoaFeesTerm.divisor
            payment += monthlyPropertyTax + monthlyHomeInsurance + monthlyPmi + monthlyHoa
        }
        
        return payment
    }
}

#Preview {
    MortgagePaymentCalculator()
}
