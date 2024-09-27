//
//  GoalLineCapitalApp.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/25/24.
//

import SwiftUI
import SwiftData

@main
struct GoalLineCapitalApp: App {
    var body: some Scene {
        WindowGroup {
            ToolsView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
