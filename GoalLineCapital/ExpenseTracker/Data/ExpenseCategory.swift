//
//  Category.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/8/24.
//

import Foundation
import SwiftData

@Model
class ExpenseCategory : Identifiable, Hashable {
    static let defaultCategory = ExpenseCategory(name: "Uncategorized", symbol: "💸")
    
    var id = UUID()
    var name: String = ""
    //var symbol: Character = "💸"
    @Relationship(inverse: \ExpenseItem.category) var items: [ExpenseItem]?
    
    init(name: String, symbol: Character, items: [ExpenseItem] = []) {
        self.name = name
        //self.symbol = symbol
        self.items = items
    }
}
