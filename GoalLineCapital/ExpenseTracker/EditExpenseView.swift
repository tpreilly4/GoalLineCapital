//
//  AddExpenseView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 3/8/24.
//

import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query var categories: [ExpenseCategory]
        
    @State private var showDeleteDialog = false
    
    let itemModel : ExpenseItem?
    @State private var amount: Double = 0.0
    @State private var date = Date()
    @State private var category: ExpenseCategory?
    @State private var details = ""
    @State private var didInitializeItem = false
    @State private var isInputValid: Bool = false
        
    var body: some View {
        NavigationStack{
            VStack{
//                InputExpenseItemView(amount: $amount, date: $date, category: $category, details: $details)
                
                Button("Save", systemImage: "square.and.arrow.down.fill") {
                    save()
                }
                .padding()
                .disabled(!validateInput())
                
                Spacer()
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
            .toolbar() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteDialog.toggle()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
            }
            .confirmationDialog(
                "Are you sure you want to delete this?",
                isPresented: $showDeleteDialog,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    deleteExpenseItem()
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.large)
        }

    }
    
    func save() {
        // here
        if let itemModel {
            // expense already exists, edit it
            itemModel.amount = amount
            itemModel.date = date
            itemModel.category = category
            itemModel.details = details
            dismiss()
        }
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
    
    // here, edit screen only
    func deleteExpenseItem() {
        guard let itemModel else { return }
        modelContext.delete(itemModel)
        dismiss()
    }
}

#Preview {
    EditExpenseView(itemModel: nil)
}
