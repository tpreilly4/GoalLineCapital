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
        ViewThatFits(in: .horizontal) {
            HStack {
                slider
                Spacer(minLength: 12)
                percentField
            }
            VStack(alignment: .trailing, spacing: 8) {
                percentField
                slider
            }
        }
    }

    private var slider: some View {
        Slider(value: $value, in: range, step: step)
            .frame(maxWidth: 260)
    }

    private var percentField: some View {
        TextField("Rate", value: $value, format: .percent)
            .fixedSize()
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
