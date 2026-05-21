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
        ViewThatFits(in: .horizontal) {
            HStack {
                Text(title)
                Spacer()
                valueText
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            VStack(alignment: .leading) {
                Text(title)
                HStack {
                    Spacer()
                    valueText
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding([.vertical], 5)
    }

    private var valueText: Text {
        Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .fontWeight(.bold)
            .font(.title)
    }
}

#Preview {
    DollarOutputView(title: "Title", value: 150.0)
}
