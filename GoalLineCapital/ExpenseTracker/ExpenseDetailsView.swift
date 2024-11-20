//
//  ExpenseDetailsView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/8/24.
//

import SwiftUI

struct ExpenseDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var item: ExpenseItem

    var body: some View {
        NavigationStack{
            VStack{
                EditExpenseView(itemModel: item)
            }
        }
    }
}

#Preview {
    ExpenseDetailsView(item: (ExpenseItem(amount: 50.0, date: Date.now, category: ExpenseCategory(name: "Groceries", symbol: "🛒"), details: "Whole Foods")))
}
