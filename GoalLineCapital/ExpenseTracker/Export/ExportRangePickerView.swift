//
//  ExportRangePickerView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import SwiftUI

struct ExportRangePickerView: View {
    let allExpenses: [ExpenseItem]

    @Environment(\.dismiss) private var dismiss
    @State private var startMonth: String = ""
    @State private var endMonth: String = ""
    @State private var isGenerating = false
    @State private var generatedURL: URL?
    @State private var errorMessage: String?

    private var availableMonths: [String] {
        let unique = Set(allExpenses.map { $0.monthAndYear })
        return unique.sorted { !monthYearSorter($0, $1) } // oldest → newest
    }

    private var isValidRange: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        guard let start = formatter.date(from: startMonth),
              let end = formatter.date(from: endMonth) else { return false }
        return start <= end
    }

    private var rangeExpenseCount: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        guard let start = formatter.date(from: startMonth),
              let end = formatter.date(from: endMonth) else { return 0 }
        return allExpenses.filter { item in
            guard let date = formatter.date(from: item.monthAndYear) else { return false }
            return date >= start && date <= end
        }.count
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Date Range") {
                    if availableMonths.isEmpty {
                        Text("No expenses recorded yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Start Month", selection: $startMonth) {
                            ForEach(availableMonths, id: \.self) { month in
                                Text(month).tag(month)
                            }
                        }
                        Picker("End Month", selection: $endMonth) {
                            ForEach(availableMonths, id: \.self) { month in
                                Text(month).tag(month)
                            }
                        }
                        if !startMonth.isEmpty && !endMonth.isEmpty && !isValidRange {
                            Text("End month must be on or after start month.")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                }

                if !startMonth.isEmpty && !endMonth.isEmpty && isValidRange {
                    Section {
                        Text("\(rangeExpenseCount) expense(s) in selected range")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let message = errorMessage {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Export Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isGenerating {
                        ProgressView()
                    } else if let url = generatedURL {
                        ShareLink(
                            item: url,
                            preview: SharePreview(
                                "Expense Report",
                                image: Image(systemName: "doc.richtext")
                            )
                        ) {
                            Label("Share PDF", systemImage: "square.and.arrow.up")
                        }
                    } else {
                        Button("Generate PDF") {
                            generatePDF()
                        }
                        .disabled(!isValidRange || availableMonths.isEmpty)
                    }
                }
            }
            .onAppear {
                startMonth = availableMonths.first ?? ""
                endMonth = availableMonths.last ?? ""
            }
            .onChange(of: startMonth) { generatedURL = nil; errorMessage = nil }
            .onChange(of: endMonth) { generatedURL = nil; errorMessage = nil }
        }
    }

    private func generatePDF() {
        isGenerating = true
        generatedURL = nil
        errorMessage = nil
        Task { @MainActor in
            do {
                let url = try ExpensePDFGenerator().generate(
                    expenses: allExpenses,
                    startMonth: startMonth,
                    endMonth: endMonth
                )
                generatedURL = url
            } catch ExportError.noData {
                errorMessage = "No expenses found for the selected range."
            } catch {
                errorMessage = "Could not generate PDF."
            }
            isGenerating = false
        }
    }
}
