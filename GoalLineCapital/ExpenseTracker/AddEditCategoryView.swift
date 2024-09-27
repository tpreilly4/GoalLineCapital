//
//  AddEditCategoryView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/22/24.
//

import SwiftUI

struct AddEditCategoryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var symbol: String = ""
    @State private var color: Color = Color.black
    
    var charSymbol: Character {
        let c = symbol.first ?? " "
        return c
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    TextField("Category Name", text: $name)
                    TextField("Symbol", text: $symbol)
                    ColorPicker("Category Color", selection: $color)
                }
                Button("Done") {
                    modelContext.insert(ExpenseCategory(name: name, symbol: charSymbol))
                    dismiss()
                }
                Spacer()
            }
            .navigationTitle("New Category")
        }
    }
}

#Preview {
    AddEditCategoryView()
}
