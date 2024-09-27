//
//  ExpenseListItemView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/8/24.
//

import SwiftUI

struct ExpenseListItemView: View {
    let date: Date
    let details: String
    let amount: Double
    
    var body: some View {
        HStack{
            Text(date, format: .dateTime.day().month())
            Spacer()
            Text(details)
            Spacer()
            Text(amount, format: .currency(code: "USD"))
        }
    }
}

#Preview {
    ExpenseListItemView(date: Date.now, details: "Details here", amount: 69.69)
}
