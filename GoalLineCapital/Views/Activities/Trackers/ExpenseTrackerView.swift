//
//  ExpenseTrackerView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI
import SwiftData

struct ExpenseTrackerView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ExpenseItem.date, order:.reverse) var allExpenses: [ExpenseItem]
    
    @State private var showingDetails = false
    
    private var Settings = ["Categories"]
        
    var body: some View {
        let groupedExpenses = Dictionary(grouping: allExpenses) {
            $0.monthAndYear
        }
                
        NavigationStack {
            AddExpenseView()
            
            List{
                ForEach(groupedExpenses.keys.sorted{ return monthYearSorter(this: $0, that: $1) }, id: \.self) { month in
                    Section() {
                        ForEach(groupedExpenses[month]!.prefix(3), id: \.id) { item in
                            NavigationLink {
                                ExpenseDetailsView(item: item)
                            } label: {
                                ExpenseListItemView(date: item.date, details: item.details, amount: item.amount)
                            }
                        }
                        .onDelete{ offsets in
                            let itemsToDelete = offsets.map { groupedExpenses[month]![$0] }
                            for item in itemsToDelete {
                                modelContext.delete(item)
                            }
                        }
                    } header: {
                        NavigationLink {
                            MonthView(thismonth: month)
                        } label : {
                            HStack {
                                Text(month)
                                Spacer()
                                Text((groupedExpenses[month]!.reduce(0){$0 + $1.amount}), format: .currency(code: "USD"))
                                Image(systemName: "chevron.forward")
                            }
                            .font(.title3)
                            .padding(4)
                        }
                    }
                    .textCase(.none)
                }
            }
            .navigationTitle("Expense Tracker")
            .toolbar {
                ToolbarItem {
                    Menu {
                        ForEach(Settings, id: \.self) { option in
                            NavigationLink(option) {
                                CategoryListView()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BrandingGradients().brandingGradient)
        }
    }
    
    func monthYearSorter(this: String, that: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // "MMMM" for full month name, "yyyy" for 4-digit year
        
        // Parse the strings as dates
        guard let date1 = formatter.date(from: this),
              let date2 = formatter.date(from: that) else {
          return false // Handle parsing errors as needed
        }
        
        // Sort by date
        return date1 > date2
    }
}

#Preview {
    ExpenseTrackerView()
}
