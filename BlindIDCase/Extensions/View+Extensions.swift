//
//  View+Extensions.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI

extension View {
    // MARK: - Check Module Type
    public func isVisible(_ bool: Bool) -> some View {
        modifier(VisibilityModifier(isVisible: bool))
    }
}
