//
//  MonthYearSorter.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 5/22/26.
//

import Foundation

func monthYearSorter(_ a: String, _ b: String) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    guard let dateA = formatter.date(from: a),
          let dateB = formatter.date(from: b) else { return false }
    return dateA > dateB
}
