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

    private enum Layout {
        static let pageHeight: CGFloat   = 792
        static let headerHeight: CGFloat = 54   // blue title bar
        static let hPadding: CGFloat     = 32   // 16pt each side
        static let summaryBlock: CGFloat = 252  // pie chart + Total Spending + dividers/spacing
        static let footerHeight: CGFloat = 35   // Month Total row + divider

        static var firstPageBudget: CGFloat {
            pageHeight - headerHeight - hPadding - summaryBlock - footerHeight
        }
        static var laterPageBudget: CGFloat {
            pageHeight - headerHeight - hPadding - footerHeight
        }
        static func groupHeight(_ itemCount: Int) -> CGFloat {
            26 + CGFloat(itemCount) * 22 + 16
        }
    }

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
            let monthItems = grouped[month]!
            let categories = groupedByCategory(monthItems)
            let pages = paginateCategories(
                categories,
                firstBudget: Layout.firstPageBudget,
                laterBudget: Layout.laterPageBudget
            )
            for (i, pageCategories) in pages.enumerated() {
                renderPage(ReportMonthSection(
                    month: month,
                    allItems: monthItems,
                    pageCategories: pageCategories,
                    showSummary: i == 0,
                    isLastPage: i == pages.count - 1,
                    isContinuation: i > 0
                ), ctx: ctx, box: box)
            }
        }

        ctx.closePDF()
        return url
    }

    private func groupedByCategory(_ items: [ExpenseItem]) -> [(String, [ExpenseItem])] {
        let grouped = Dictionary(grouping: items) { $0.category?.name ?? "Uncategorized" }
        return grouped.sorted { $0.key < $1.key }
    }

    private func paginateCategories(
        _ groups: [(String, [ExpenseItem])],
        firstBudget: CGFloat,
        laterBudget: CGFloat
    ) -> [[(String, [ExpenseItem])]] {
        var pages: [[(String, [ExpenseItem])]] = [[]]
        var remaining = firstBudget
        for group in groups {
            let h = Layout.groupHeight(group.1.count)
            if h > remaining, !pages.last!.isEmpty {
                pages.append([])
                remaining = laterBudget
            }
            pages[pages.endIndex - 1].append(group)
            remaining -= h
        }
        return pages
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
