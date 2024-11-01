//
//  EmojiIconLabel.swift
//  GoalLineCapital
//
//  Created by Tom Reilly on 9/27/24.
//

import SwiftUI

extension Label where Title == Text, Icon == Text {
    init(_ title: String, emoji: String) {
        self.init {
            Text(title)
        } icon: {
            Text(emoji)
        }
    }
}
