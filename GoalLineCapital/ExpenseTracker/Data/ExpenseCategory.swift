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
    static let defaultCategory = ExpenseCategory(name: "Uncategorized")
    
    var id = UUID()
    var name: String = ""
    @Relationship(inverse: \ExpenseItem.category) var items: [ExpenseItem]?
    
    init(name: String, items: [ExpenseItem] = []) {
        self.name = name
        self.items = items
    }
}
