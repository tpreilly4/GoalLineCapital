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
    
    @Binding var amount: Double
    @Binding var date: Date
    @Binding var category: ExpenseCategory?
    @Binding var details: String
        
    var body: some View {
        VStack{
            HStack{
                TextField("What did you buy?", text: $details)
                DatePicker(selection: $date, displayedComponents: .date){}
            }
            .cardViewWrapper()
            
            HStack{
                TextField("How much was it?", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
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
            }
            .cardViewWrapper()
        }
        .padding([.horizontal,.top])
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            AddCategoryView()
        }
    }
    
    func resetInputs(){
        amount = 0.0
        details = ""
        category = nil
    }
}

//#Preview {
//    ExpenseInputView()
//}
