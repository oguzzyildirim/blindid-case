//
//  VisibilityModifier.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI

struct VisibilityModifier: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        Group {
            if isVisible {
                content
            } else {
                EmptyView()
            }
        }
    }
}
