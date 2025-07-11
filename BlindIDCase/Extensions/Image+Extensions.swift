//
//  Image+Extensions.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI

extension Image {
    static func fromURL(_ urlString: String, placeholder: Image = Image(systemName: "photo")) -> some View {
        AsyncImage(
            url: URL(string: urlString),
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            },
            placeholder: {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.3))
            }
        )
    }
}
