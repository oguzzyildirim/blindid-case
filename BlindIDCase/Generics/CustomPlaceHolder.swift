//
//  CustomPlaceHolder.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 26.05.2025.
//

import SwiftUI

struct CustomPlaceHolder: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .frame(width: 140, height: 210)
            .cornerRadius(16)
    }
}

#Preview {
    CustomPlaceHolder()
}
