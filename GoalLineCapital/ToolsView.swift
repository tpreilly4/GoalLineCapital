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
                            showingTipCalculatorView.toggle()
                        } label : {
                            Label("Mortgage Payment Estimator", systemImage: "house")
                        }
                        Button {
                            showingExpenseSplitterView.toggle()
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
                            if let url = URL(string: "https://calendly.com/bobby-goallinecapital/booking") { openURL(url) }
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
            }
            
        }
    }
}

#Preview {
    ToolsView()
}
