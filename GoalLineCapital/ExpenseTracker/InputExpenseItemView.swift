//
//  InputExpenseItemView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/20/24.
//

import SwiftUI
import SwiftData

struct InputExpenseItemView: View {
    @Query var categories: [ExpenseCategory]
        
    @State private var showingNewCategoryAlert = false

    @Binding var expenseAmountString: String
    @Binding var date: Date
    @Binding var category: ExpenseCategory?
    @Binding var details: String
            
    @FocusState private var isDetailsFocused: Bool
    @FocusState private var isAmountFocused: Bool
    
    var body: some View {
        VStack{
            HStack{
                TextField("What did you buy?", text: $details)
                    .focused($isDetailsFocused)
                DatePicker(selection: $date, displayedComponents: .date){}
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
                Picker("", selection: $category){
                    if category == nil {
                        Text("Choose a Category")
                            .tag(nil as ExpenseCategory?)
                    }
                    ForEach(categories) { cat in
                        Text(cat.name)
                            .tag(cat as ExpenseCategory?)
                    }
                    Button("Add New") { showingNewCategoryAlert.toggle() }
                }
                .pickerStyle(.navigationLink)
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
                        Button("Next") {
                            isDetailsFocused = false
                            isAmountFocused = true
                        }
                    }
                    Spacer()
                    Button("Done") {
                        isDetailsFocused = false
                        isAmountFocused = false
                    }
                    .fontWeight(.bold)
                }
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
