//
//  ExpenseItem.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/6/24.
//

import Foundation
import SwiftData

@Model
class ExpenseItem : Identifiable, Hashable {
    var id = UUID()
    var amount: Double = 0.0
    var date: Date = Date()
    var category: ExpenseCategory?
    var details: String = ""
    var monthAndYear: String = ""
    
    init(amount: Double, date: Date, category: ExpenseCategory?, details: String) {
        self.amount = amount
        self.date = date
        self.details = details
        self.monthAndYear = date.monthAndYear
        
        if category == nil {
            self.category = ExpenseCategory.defaultCategory
        } else {
            self.category = category
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ExpenseItem, rhs: ExpenseItem) -> Bool {
        return lhs.id == rhs.id
    }
}
