//
//  AddCategoryView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/22/24.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.modelContext) var modelContext
    @State private var name: String = ""
    
    var body: some View {
        VStack{
            TextField("Category Name", text: $name)
            Button("Save", action: saveCategory)
            Button("Cancel", role: .cancel, action: resetInputs)
        }
    }
    
    private func saveCategory() {
        if !name.isEmpty {
            modelContext.insert(ExpenseCategory(name: name))
        }
        resetInputs()
    }
    
    private func resetInputs() {
        name = ""
    }
}

#Preview {
    AddCategoryView()
}
