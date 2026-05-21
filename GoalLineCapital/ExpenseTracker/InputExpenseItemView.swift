//
//  InputExpenseItemView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/20/24.
//

import SwiftUI
import SwiftData

struct InputExpenseItemView: View {
    @Query(sort: \ExpenseCategory.name) var categories: [ExpenseCategory]
        
    @State private var showingNewCategoryAlert = false

    @Binding var expenseAmountString: String
    @Binding var date: Date
    @Binding var category: ExpenseCategory?
    @Binding var details: String
            
    @FocusState private var isDetailsFocused: Bool
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isDateFocused: Bool
    @State private var datePickerId: Int = 0
    
    var body: some View {
        VStack{
            HStack{
                TextField("What did you buy?", text: $details)
                    .focused($isDetailsFocused)
                DatePicker("", selection: $date, displayedComponents: .date)
                    .focused($isDateFocused)
                    .id(datePickerId)
                    .onChange(of: date) {
                        // little hacky solution for hiding date picker after selection
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            datePickerId += 1
                        }
                    }
            }
            .cardViewWrapper()
            
            HStack{
                if (!expenseAmountString.isEmpty){
                    Text("$")
                }
                
                TextField("How much was it?", text: $expenseAmountString)
                    .keyboardType(.decimalPad)
                    .focused($isAmountFocused)
                    .easyDollarInput(with: $expenseAmountString)
                
                // Category picker
                Menu {
                    Button(role: .none) {
                        showingNewCategoryAlert = true
                    } label: {
                        Label("Add New", systemImage: "plus")
                    }
                    Divider()
                    ForEach(categories) { cat in
                        Button(cat.name) { category = cat }
                    }
                } label: {
                    Text(category?.name ?? "Choose a Category")
                }
                .id(category?.id)
                .alert("New Category", isPresented: $showingNewCategoryAlert) {
                    AddCategoryView()
                }
            }
            .cardViewWrapper()
            .onChange(of: isAmountFocused) {
                self.expenseAmountString = formatDollarAmount(amount: expenseAmountString, includeCents: true) ?? expenseAmountString
            }
        }
        .padding([.horizontal,.top])
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    if isDetailsFocused {
                        Button("Amount") {
                            isDetailsFocused = false
                            isAmountFocused = true
                        }
                    }
                    Spacer()
                    Button {
                        // hide keyboard
                        isDetailsFocused = false
                        isAmountFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundStyle(.tint)
                    }
                }
            }
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            AddCategoryView()
        }
        // New categories are selected automatically
        .onChange(of: categories) { oldCategories, newCategories in
            if let newCategory = newCategories.first(where: { cat in
                !oldCategories.contains(where: { $0.id == cat.id })
            }) {
                category = newCategory
            }
        }
    }
    
    func resetInputs(){
        expenseAmountString = ""
        details = ""
        category = nil
    }
}

//#Preview {
//    ExpenseInputView()
//}
