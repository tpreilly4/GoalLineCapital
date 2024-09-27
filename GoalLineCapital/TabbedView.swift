//
//  TabbedView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct TabbedView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            TrackView()
                .tabItem{
                    Label("Track", systemImage: "chart.line.uptrend.xyaxis")
                }
//            PlanView()
//                .tabItem{
//                    Label("Plan", systemImage: "lightbulb.min")
//                }
            ToolsView()
                .tabItem{
                    Label("Tools", systemImage: "wrench.and.screwdriver")
                }
        }
    }
}

#Preview {
    TabbedView()
}
