//
//  MonthView.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/2/24.
//

import SwiftUI
import SwiftData

struct MonthView: View {
    @Environment(\.modelContext) var modelContext
    @Query var monthExpenses: [ExpenseItem]
    @Query var allCategories: [ExpenseCategory]
    @State private var isGrouped = true
        
    private var month: String
    
    init(thismonth: String) {
        month = thismonth
        let predicate = #Predicate<ExpenseItem> { item in
            thismonth == item.monthAndYear
        }
        _monthExpenses = Query(filter: predicate, sort: \ExpenseItem.date, order:.reverse)
    }
    
    var body: some View {
        let categorizedExpenses = Dictionary(grouping: monthExpenses) {
            if let key = $0.category {
                return key
            } else {
                return ExpenseCategory.defaultCategory
            }
        }
        
        NavigationStack{
            List {
                if isGrouped {
                    ForEach(categorizedExpenses.keys.sorted {$0.name < $1.name}, id: \.id) { catkey in
                        Section() {
                            ForEach(categorizedExpenses[catkey] ?? [], id: \.id) { item in
                                NavigationLink {
                                    ExpenseDetailsView(item: item)
                                } label: {
                                    ExpenseListItemView(date: item.date, details: item.details, amount: item.amount)
                                }
                            }
                            .onDelete{ offsets in
                                let itemsToDelete = offsets.map { categorizedExpenses[catkey]![$0] }
                                for item in itemsToDelete {
                                    modelContext.delete(item)
                                }
                            }
                        } header: {
                            HStack {
                                Text(catkey.name)
                                Spacer()
                                Text((categorizedExpenses[catkey]!.reduce(0){$0 + $1.amount}), format: .currency(code: "USD"))
                            }
                            .font(.title3)
                            .padding(4)
                        }
                        .textCase(.none)
                    }
                } else {
                    // TODO fix this copy & pasted code
                    ForEach(monthExpenses, id: \.id) { item in
                        NavigationLink {
                            ExpenseDetailsView(item: item)
                        } label: {
                            ExpenseListItemView(date: item.date, details: item.details, amount: item.amount)
                        }
                    }
                    .onDelete{ offsets in
                        let itemsToDelete = offsets.map { monthExpenses[$0] }
                        for item in itemsToDelete {
                            modelContext.delete(item)
                        }
                    }
                }
            }
        }
        .navigationTitle(month)
        .toolbar {
            Menu("Sort", systemImage: "list.bullet.indent") {
                Picker("Sort", selection: $isGrouped) {
                    Text("Group by Category")
                        .tag(true)
                    Text("Order By Date")
                        .tag(false)
                }
            }
        }
    }
}
