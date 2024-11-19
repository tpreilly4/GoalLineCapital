//
//  Gradients.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 11/19/24.
//

import SwiftUI

struct BrandingGradients {
    let brandingGradient = LinearGradient(stops: [
        Gradient.Stop(color: .goalLineBlue .opacity(0.5), location: 0),
        Gradient.Stop(color: .clear, location: 1),
    ], startPoint: .bottom, endPoint: .topTrailing)
}
