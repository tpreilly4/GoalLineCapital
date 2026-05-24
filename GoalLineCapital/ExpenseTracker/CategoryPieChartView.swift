//
//  CategoryPieChartView.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/24/26.
//

import SwiftUI
import Charts

struct CategoryPieChartView: View {
    let items: [ExpenseItem]

    private struct CategoryData: Identifiable {
        let id = UUID()
        let name: String
        let total: Double
        let color: Color
    }

    static let palette: [Color] = [
        .blue, .green, .orange, .purple, .red,
        .cyan, .yellow, .indigo, .mint, .pink
    ]

    static func colorMap(for items: [ExpenseItem]) -> [String: Color] {
        let grouped = Dictionary(grouping: items) { $0.category?.name ?? "Uncategorized" }
        let sorted = grouped.map { ($0.key, $0.value.reduce(0) { $0 + $1.amount }) }
                            .sorted { $0.1 > $1.1 }
        var map: [String: Color] = [:]
        for (i, (name, _)) in sorted.enumerated() {
            map[name] = palette[i % palette.count]
        }
        return map
    }

    private var categoryData: [CategoryData] {
        let map = Self.colorMap(for: items)
        let grouped = Dictionary(grouping: items) { $0.category?.name ?? "Uncategorized" }
        return grouped.map { name, items in
            CategoryData(name: name, total: items.reduce(0) { $0 + $1.amount }, color: map[name] ?? .gray)
        }.sorted { $0.total > $1.total }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Chart(categoryData) { cat in
                SectorMark(
                    angle: .value("Amount", cat.total),
                    innerRadius: .ratio(0.55),
                    angularInset: 2
                )
                .cornerRadius(4)
                .foregroundStyle(cat.color)
            }
            .frame(width: 160, height: 160)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(categoryData) { cat in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(cat.color)
                            .frame(width: 8, height: 8)
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
