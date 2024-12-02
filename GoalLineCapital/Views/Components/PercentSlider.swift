//
//  PercentSlider.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/12/24.
//

import SwiftUI

struct PercentSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    @FocusState private var percentIsFocused: Bool

    
    var body: some View {
        HStack{
            Slider(value: $value, in: range, step: step)
                .frame(maxWidth: 260)
            Spacer()
            TextField("Rate", value: $value, format: .percent)
                .frame(minWidth: 0, maxWidth: 60)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused($percentIsFocused)
                .toolbar {
                    if percentIsFocused {
                        ToolbarItemGroup(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button {
                                    percentIsFocused = false
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                        .foregroundStyle(.tint)
                                }
                            }
                        }
                    }
                }

        }
    }
}
