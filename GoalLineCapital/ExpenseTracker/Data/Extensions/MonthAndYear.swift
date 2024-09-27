//
//  MonthAndYear.swift
//  Dollarwise
//
//  Created by Tom Reilly on 4/2/24.
//

import Foundation

extension Date {
    var monthAndYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}
