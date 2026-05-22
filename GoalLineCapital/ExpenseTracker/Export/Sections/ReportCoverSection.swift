//
//  ReportCoverSection.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import SwiftUI

struct ReportCoverSection: View {
    let startMonth: String
    let endMonth: String

    private var dateRangeText: String {
        startMonth == endMonth ? startMonth : "\(startMonth) – \(endMonth)"
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("GoalLine Capital")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Text("Expense Report")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(Color.goalLineBlue)

            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "chart.bar.doc.horizontal.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.goalLineBlue)

                VStack(spacing: 8) {
                    Text(dateRangeText)
                        .font(.title.weight(.semibold))
                        .multilineTextAlignment(.center)
                    Text("Generated \(Date().formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text("Prepared with GoalLine Capital")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ReportCoverSection(startMonth: "January 2025", endMonth: "April 2026")
}
