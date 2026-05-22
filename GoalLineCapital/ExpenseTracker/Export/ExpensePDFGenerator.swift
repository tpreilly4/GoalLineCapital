//
//  ExpensePDFGenerator.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import SwiftUI

enum ExportError: Error {
    case contextFailed
    case noData
}

@MainActor
struct ExpensePDFGenerator {
    private let pageSize = CGSize(width: 612, height: 792) // US Letter at 72 DPI

    func generate(expenses: [ExpenseItem], startMonth: String, endMonth: String) throws -> URL {
        let filtered = filter(expenses, from: startMonth, to: endMonth)
        guard !filtered.isEmpty else { throw ExportError.noData }

        let grouped = Dictionary(grouping: filtered) { $0.monthAndYear }
        let sortedMonths = grouped.keys.sorted { monthYearSorter($0, $1) }

        let safeName = "GoalLine_Report_\(startMonth)-\(endMonth)"
            .replacingOccurrences(of: " ", with: "_")
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(safeName)
            .appendingPathExtension("pdf")

        var box = CGRect(origin: .zero, size: pageSize)
        guard let ctx = CGContext(url as CFURL, mediaBox: &box, nil) else {
            throw ExportError.contextFailed
        }

        renderPage(ReportCoverSection(startMonth: startMonth, endMonth: endMonth), ctx: ctx, box: box)
        renderPage(ReportSummarySection(expenses: filtered), ctx: ctx, box: box)
        for month in sortedMonths {
            renderPage(ReportMonthSection(month: month, items: grouped[month]!), ctx: ctx, box: box)
        }

        ctx.closePDF()
        return url
    }

    private func renderPage<V: View>(_ view: V, ctx: CGContext, box: CGRect) {
        ctx.beginPDFPage(nil)
        let renderer = ImageRenderer(content: view.frame(width: box.width, height: box.height))
        renderer.proposedSize = .init(width: box.width, height: box.height)
        renderer.scale = 2.0
        renderer.render { _, draw in draw(ctx) }
        ctx.endPDFPage()
    }

    private func filter(_ expenses: [ExpenseItem], from startMonth: String, to endMonth: String) -> [ExpenseItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        guard let start = formatter.date(from: startMonth),
              let end = formatter.date(from: endMonth) else { return expenses }
        return expenses.filter { item in
            guard let date = formatter.date(from: item.monthAndYear) else { return false }
            return date >= start && date <= end
        }
    }
}
