//
//  TermType.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/7/24.
//

import Foundation

enum TermType: CaseIterable, Identifiable, CustomStringConvertible {
    case monthly
    case quarterly
    case yearly
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .monthly:
            return "Monthly"
        case .quarterly:
            return "Quarterly"
        case .yearly:
            return "Yearly"
        }
    }
    
    var divisor: Double {
        switch self {
        case .monthly:
            return 1
        case .quarterly:
            return 3
        case .yearly:
            return 12
        }
    }
}
