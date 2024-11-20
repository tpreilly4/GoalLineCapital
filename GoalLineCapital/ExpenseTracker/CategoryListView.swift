//
//  CategoryListView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/6/24.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var categories: [ExpenseCategory]
    
    @State private var showingAddCategoryAlert = false
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(categories) { category in
                    Text(category.name)
                        .tag(category as ExpenseCategory)
                }
                .onDelete { offsets in
                    for offset in offsets {
                        let cat = categories[offset]
                        modelContext.delete(cat)
                    }
                }
                Button("Add New") {
                    showingAddCategoryAlert.toggle()
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                EditButton()
            }
            .alert("New Category", isPresented: $showingAddCategoryAlert) {
                AddCategoryView()
            }
        }
    }
}

#Preview {
    CategoryListView()
}
