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

    @State private var showExportSheet = false

    private var Settings = ["Categories"]

    private var CurrentMonth = Date().monthAndYear
        
    var body: some View {
        let groupedExpenses = Dictionary(grouping: allExpenses) {
            $0.monthAndYear
        }
                
        NavigationStack {
            AddExpenseView()
            
            List{
                ForEach(groupedExpenses.keys.sorted { monthYearSorter($0, $1) }, id: \.self) { month in
                    Section() {
                        ForEach(groupedExpenses[month]!.prefix(month == CurrentMonth ? 20 : 5), id: \.id) { item in
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
                        Button("Export Report", systemImage: "square.and.arrow.up") {
                            showExportSheet = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showExportSheet) {
                ExportRangePickerView(allExpenses: allExpenses)
            }
            .scrollContentBackground(.hidden)
            .background(BrandingGradients().brandingGradient)
        }
    }
    
}

#Preview {
    ExpenseTrackerView()
}
