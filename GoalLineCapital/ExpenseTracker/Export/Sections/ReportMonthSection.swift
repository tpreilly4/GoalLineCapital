//
//  ReportMonthSection.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import SwiftUI

struct ReportMonthSection: View {
    let month: String
    let allItems: [ExpenseItem]
    let pageCategories: [(String, [ExpenseItem])]
    let showSummary: Bool
    let isLastPage: Bool
    let isContinuation: Bool

    private var total: Double {
        allItems.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isContinuation ? "\(month) (continued)" : month)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.goalLineBlue)

            VStack(alignment: .leading, spacing: 16) {
                if showSummary {
                    CategoryPieChartView(items: allItems)

                    Divider()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monthly Total")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(total, format: .currency(code: "USD"))
                            .font(.title.weight(.bold))
                            .foregroundStyle(Color.goalLineBlue)
                    }

                    Divider()
                }

                ForEach(pageCategories, id: \.0) { categoryName, categoryItems in
                    categoryGroup(name: categoryName, items: categoryItems)
                }

                if isLastPage {
                    Divider()

                    HStack {
                        Text("Month Total")
                            .font(.subheadline.weight(.bold))
                        Spacer()
                        Text(total, format: .currency(code: "USD"))
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(Color.goalLineBlue)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }

    private func categoryGroup(name: String, items: [ExpenseItem]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(items.reduce(0) { $0 + $1.amount }, format: .currency(code: "USD"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.goalLineBlue)
            }

            ForEach(items.sorted { $0.date > $1.date }, id: \.id) { item in
                HStack(spacing: 8) {
                    Text(item.date, format: .dateTime.month(.abbreviated).day())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 44, alignment: .leading)
                    Text(item.details.isEmpty ? "—" : item.details)
                        .font(.caption)
                        .lineLimit(1)
                    Spacer()
                    Text(item.amount, format: .currency(code: "USD"))
                        .font(.caption)
                }
                .padding(.leading, 8)
            }

            Divider()
        }
    }
}
