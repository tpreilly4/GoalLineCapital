//
//  AddEditExpenseView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/8/24.
//

import SwiftUI
import SwiftData

private extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }
}

struct AddEditExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var categories: [ExpenseCategory]
        
    @State private var showingNewCategoryView = false
    @State private var newCategoryText = ""
    
    let itemModel : ExpenseItem?
    @State private var amount: Double = 0.0
    @State private var date = Date()
    @State private var category: ExpenseCategory?
    @State private var details = ""
    @State private var didInitializeItem = false
        
    var body: some View {
        VStack{
            HStack{
                TextField("What did you buy?", text: $details)
                DatePicker(selection: $date, displayedComponents: .date){}
            }
            .cardViewWrapper()
            
            HStack{
                TextField(itemModel != nil ? "Amount" : "How much was it?", value: $amount, format: .currency(code: "USD")).keyboardType(.decimalPad)
                Picker("", selection: $category){
                    if category == nil {
                        Text("Choose a Category")
                            .tag(nil as ExpenseCategory?)
                    }
                    ForEach(categories) { cat in
                        Text(cat.name)
                            .tag(cat as ExpenseCategory?)
                    }
                    Button("Add New") { showingNewCategoryView.toggle() }
                }
                .pickerStyle(.navigationLink)
            }
            .cardViewWrapper()
            Button(itemModel != nil ? "Save" : "Add", systemImage: itemModel != nil ? "square.and.arrow.down.fill" : "plus.circle.fill") { save() }
            .padding()
            .disabled(!expenseIsValid())
            if (itemModel != nil){
                Spacer()
            }
        }
        .padding([.horizontal,.top])
        .sheet(isPresented: $showingNewCategoryView) {
            AddEditCategoryView()
        }
        .onAppear() {
            if let itemModel {
                if !didInitializeItem {
                    didInitializeItem = true
                    amount = itemModel.amount
                    date = itemModel.date
                    category = itemModel.category
                    details = itemModel.details
                }
            }
        }
    }
    
    func save() {
        if let itemModel {
            // expense already exists, edit it
            itemModel.amount = amount
            itemModel.date = date
            itemModel.category = category
            itemModel.details = details
            dismiss()
        } else {
            // add a new expense
            let newExpense = ExpenseItem(amount: amount, date: date, category: category, details: details)
            modelContext.insert(newExpense)
            resetInputs()
        }
    }
    
    func resetInputs(){
        amount = 0.0
        details = ""
        category = nil
    }
    
    func expenseIsValid() -> Bool {
        if category == nil { return false }
        if details.trimmingCharacters(in: .whitespaces).isEmpty { return false }
        if amount == 0.0 { return false }
        return true
    }
}

#Preview {
    AddEditExpenseView(itemModel: nil)
}
