//
//  DollarOutputView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/6/24.
//

import SwiftUI

struct DollarOutputView: View {
    var title: String
    var value: Double
    var body: some View {
        HStack{
            Text(title)
            Spacer()
            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .fontWeight(.bold)
                .font(.title)
        }
        .padding([.vertical],5)
    }
}

#Preview {
    DollarOutputView(title: "Title", value: 150.0)
}
