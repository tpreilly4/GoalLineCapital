//
//  HomeView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack{
            Image("GLC-logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 800)
                .padding()
            List {
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
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
