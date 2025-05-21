//
//  SplashView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
                .onAppear(perform: viewModel.onAppear)
                .onDisappear(perform: viewModel.onDisappear)
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

#Preview {
    SplashView(viewModel: SplashViewModel())
}
