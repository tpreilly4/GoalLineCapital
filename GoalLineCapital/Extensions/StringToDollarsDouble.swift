//
//  StringToDollarsDouble.swift
//  GoalLineCapital
//
//  Quick extension that converts Strings to Doubles
//  for ease of use with DollarAmountTextField
//
//  Created by Tom Reilly on 11/7/24.
//

import Foundation

extension String {
    var toDoubleAmount: Double {
        if self.isEmpty {
            return 0.0
        }
        
        if let decimalAmount = Double(self) {
            return decimalAmount
        } else {
            print("Error converting string to Double")
            return 0.0
        }
    }
}
