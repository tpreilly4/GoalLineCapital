//
//  ToolsView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct ToolsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL

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
                    .frame(maxWidth: 800)
                    .padding()
                List{
                    Section(header: Text("Tools")){
                        Button {
                            showingTipCalculatorView.toggle()
                        } label : {
                            Label("Tip Calculator", systemImage: "percent")
                        }
                        Button {
                            showingExpenseSplitterView.toggle()
                        } label : {
                            Label("Expense Splitter", systemImage: "chart.pie")
                        }
                        Button {
                            showingMortgagePaymentCalculatorView.toggle()
                        } label : {
                            Label("Mortgage Payment Estimator", systemImage: "house")
                        }
                        Button {
                            showingCompoundInterestCalculatorView.toggle()
                        } label : {
                            Label("Compound Interest Calculator", systemImage: "chart.line.uptrend.xyaxis")
                        }
                    }
                    Section(header: Text("Tracking")){
                        NavigationLink {
                            TrackView()
                        } label: {
                            Label("Expense Tracker", systemImage: "dollarsign.arrow.circlepath")
                        }
                    }
                    Section(header: Text("Contact Us")){
                        Button {
                            showingCalendlyView.toggle()
                        } label : {
                            Label("Set up a meeting", systemImage: "calendar")
                        }
                        Button {
                            if let phoneURL = URL(string: "tel://9089386361") { openURL(phoneURL) }
                        } label : {
                            Label("Call us", systemImage: "phone")
                        }
                        Button {
                            if let emailURL = URL(string: "mailto:info@GoalLineCapital.com") { openURL(emailURL) }
                        } label : {
                            Label("Email us", systemImage: "mail")
                        }
                        Button {
                            let address = "161 Madison Ave, Ste 230, Morristown, NJ 07960"
                                            if let mapsURL = URL(string: "http://maps.apple.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
                                                openURL(mapsURL)
                                            }
                        } label : {
                            Label("Find us", systemImage: "map")
                        }
                    }
                }
                .sheet(isPresented: $showingTipCalculatorView) {
                    TipCalculatorView()
                }
                .sheet(isPresented: $showingExpenseSplitterView) {
                    ExpenseSplitterView()
                }
                .sheet(isPresented: $showingMortgagePaymentCalculatorView) {
                    MortgagePaymentCalculator()
                }
                .sheet(isPresented: $showingCompoundInterestCalculatorView) {
                    CompundInterestCalculator()
                }
                .sheet(isPresented: $showingCalendlyView) {
                    if let url = URL(string: "https://calendly.com/bobby-goallinecapital/booking") { SafariView(url: url)}
                }
            }
            
        }
    }
}

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        // Customize the Safari view controller if needed
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No dynamic updates required
    }
}

#Preview {
    ToolsView()
}
