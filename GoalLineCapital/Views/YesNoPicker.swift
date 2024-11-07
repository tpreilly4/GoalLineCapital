//
//  YesNoPicker.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/7/24.
//

import SwiftUI

struct YesNoPicker: View {
    @Binding var selection: Bool
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach([false, true], id:\.self) {
                Text($0 == true ? "Yes" : "No")
            }
        }
        .pickerStyle(.segmented)
    }
}
