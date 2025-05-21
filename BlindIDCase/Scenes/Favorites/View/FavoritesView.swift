//
//  FavoritesView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    var body: some View {
        Text("Favorites")
    }
}

#Preview {
    FavoritesView()
}
