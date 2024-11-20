//
//  AddExpenseView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/8/24.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var categories: [ExpenseCategory]
        
    @State private var newCategoryText = ""
    @State private var showDeleteDialog = false
    
    @State private var amount: Double = 0.0
    @State private var date = Date()
    @State private var category: ExpenseCategory?
    @State private var details = ""
        
    var body: some View {
        VStack{
            InputExpenseItemView(amount: $amount, date: $date, category: $category, details: $details)
            
            Button("Add", systemImage: "plus.circle.fill") {
                addExpense()
            }
            .padding()
            .disabled(!validateInput())
        }
    }
    
    func addExpense() {
        let newExpense = ExpenseItem(amount: amount, date: date, category: category, details: details)
        modelContext.insert(newExpense)
        resetInputs()
    }
    
    func resetInputs(){
        amount = 0.0
        details = ""
        category = nil
    }
    
    private func validateInput() -> Bool {
        if category == nil { return false }
        if details.trimmingCharacters(in: .whitespaces).isEmpty { return false }
        if amount == 0.0 { return false }
        return true
    }
}

#Preview {
    AddExpenseView()
}
