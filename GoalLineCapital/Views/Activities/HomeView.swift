//
//  HomeView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme

    @State private var showingTipCalculatorView = false
    @State private var showingExpenseSplitterView = false
    @State private var showingMortgagePaymentCalculatorView = false
    @State private var showingCompoundInterestCalculatorView = false
    @State private var showingCalendlyView = false
    
    var body: some View {
        NavigationStack {
            VStack{
                
                Image("GLC-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 500)
                    .padding(.horizontal, 25)
                    .padding(.top, 50)
                    .background(Color.clear)
                HStack {
                    Spacer()
                    Text("Guiding You to Your").font(.headline).italic()
                    Text("Financial Goal Line").font(.headline).italic().foregroundStyle(colorScheme == .dark ? Color.white : .goalLineBlue)
                    Spacer()
                }.padding(.vertical)
                
                List{
                    Section(header: Text("Tools")){
                        NavigationLink {
                            TipCalculatorView()
                        } label: {
                            Label("Tip Calculator", emoji: "🧾")
                        }
//                        NavigationLink {
//                            ExpenseSplitterView()
//                        } label : {
//                            Label("Expense Splitter", emoji: "🍕")
//                        }
                        NavigationLink {
                            MortgagePaymentCalculatorView()
                        } label : {
                            Label("Mortgage Payment Estimator", emoji: "🏠")
                        }
                        NavigationLink {
                            CompoundInterestCalculatorView()
                        } label : {
                            Label("Compound Interest Calculator", emoji: "📈")
                        }
                    }
                    Section(header: Text("Tracking")){
                        NavigationLink {
                            ExpenseTrackerView()
                        } label: {
                            Label("Expense Tracker", emoji: "💸")
                        }
//                        NavigationLink {
//                            SavingsTrackerView()
//                        } label: {
//                            Label("Savings Tracker", emoji: "💰")
//                        }
                    }
                    Section(header: Text("Contact")){
                        Button {
                            showingCalendlyView.toggle()
                        } label : {
                            Label("Set up a meeting", emoji: "🗓️")
                        }
                        Button {
                            if let phoneURL = URL(string: "tel://9089386361") { openURL(phoneURL) }
                        } label : {
                            Label("Give us a call", emoji: "📞")
                        }
                        Button {
                            if let emailURL = URL(string: "mailto:info@GoalLineCapital.com") { openURL(emailURL) }
                        } label : {
                            Label("Send us an email", emoji: "✉️")
                        }
                        Button {
                            let address = "12 Quimby Lane Bernardsville NJ 07924"
                                            if let mapsURL = URL(string: "http://maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                                                openURL(mapsURL)
                                            }
                        } label : {
                            Label("Come to the office", emoji: "📍")
                        }
                        Button {
                            if let websiteUrl = URL(string: "https://www.goallinecapital.com") { openURL(websiteUrl) }
                        } label : {
                            Label("Visit our website", emoji: "🔗")
                        }
                    }
                    ListEndBrandingView()
                }
                .sheet(isPresented: $showingCalendlyView) {
                    if let url = URL(string: "https://calendly.com/bobby-goallinecapital/booking") { SafariView(url: url)}
                }
                .scrollContentBackground(.hidden)
                .background(BrandingGradients().brandingGradient)
            }
        }
    }
}



#Preview {
    HomeView()
}
