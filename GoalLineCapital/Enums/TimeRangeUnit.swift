//
//  TermType.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/7/24.
//

import Foundation

enum TimeRangeUnit: CaseIterable, Identifiable, CustomStringConvertible {
    case daily
    case weekly
    case monthly
    case quarterly
    case yearly
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .quarterly:
            return "Quarterly"
        case .yearly:
            return "Yearly"
        }
    }

    var unitsPerYear: Double {
        switch self {
        case .daily:
            return 365
        case .weekly:
            return 52
        case .monthly:
            return 12
        case .quarterly:
            return 4
        case .yearly:
            return 1
        }
    }
    
    var monthsPerUnit: Double {
        switch self {
        case .daily:
            return 12 / 365
        case .weekly:
            return 12 / 52
        case .monthly:
            return 1    // 12/12
        case .quarterly:
            return 3    // 12/4
        case .yearly:
            return 12   // 12/1
        }
    }
}
