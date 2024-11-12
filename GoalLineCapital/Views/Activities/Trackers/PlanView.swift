//
//  PlanView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI

struct PlanView: View {
    var body: some View {
        VStack{
            Image(systemName: "lightbulb.min")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Plan!")
        }
        .padding()
    }
}

#Preview {
    PlanView()
}
