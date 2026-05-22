//
//  ReportSummarySection.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import SwiftUI
import Charts

struct ReportSummarySection: View {
    let expenses: [ExpenseItem]

    private struct CategoryData: Identifiable {
        let id = UUID()
        let name: String
        let total: Double
    }

    private struct MonthData: Identifiable {
        let id = UUID()
        let label: String
        let total: Double
        let sortDate: Date
    }

    private var total: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    private var categoryData: [CategoryData] {
        let grouped = Dictionary(grouping: expenses) { $0.category?.name ?? "Uncategorized" }
        return grouped.map { name, items in
            CategoryData(name: name, total: items.reduce(0) { $0 + $1.amount })
        }.sorted { $0.total > $1.total }
    }

    private var monthData: [MonthData] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "MMM ''yy"
        let grouped = Dictionary(grouping: expenses) { $0.monthAndYear }
        return grouped.compactMap { month, items in
            guard let date = formatter.date(from: month) else { return nil }
            return MonthData(
                label: shortFormatter.string(from: date),
                total: items.reduce(0) { $0 + $1.amount },
                sortDate: date
            )
        }.sorted { $0.sortDate < $1.sortDate }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Summary")
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.goalLineBlue)

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Spending")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(total, format: .currency(code: "USD"))
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(Color.goalLineBlue)
                }

                if !categoryData.isEmpty {
                    Divider()
                    categoryBreakdown
                }

                if monthData.count > 1 {
                    Divider()
                    monthBreakdown
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)

            HStack(alignment: .top, spacing: 20) {
                Chart(categoryData) { cat in
                    SectorMark(
                        angle: .value("Amount", cat.total),
                        innerRadius: .ratio(0.55),
                        angularInset: 2
                    )
                    .cornerRadius(4)
                    .foregroundStyle(by: .value("Category", cat.name))
                }
                .chartLegend(.hidden)
                .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(categoryData) { cat in
                        HStack {
                            Text(cat.name)
                                .font(.caption)
                                .lineLimit(1)
                            Spacer()
                            Text(cat.total, format: .currency(code: "USD"))
                                .font(.caption.weight(.semibold))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var monthBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Totals")
                .font(.headline)

            Chart(monthData) { month in
                BarMark(
                    x: .value("Month", month.label),
                    y: .value("Amount", month.total)
                )
                .foregroundStyle(Color.goalLineBlue.gradient)
                .cornerRadius(4)
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    if let amount = value.as(Double.self) {
                        AxisValueLabel {
                            Text(amount, format: .currency(code: "USD").presentation(.narrow))
                        }
                    }
                }
            }
            .frame(height: 160)
        }
    }
}
