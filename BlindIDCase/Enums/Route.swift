//
//  Route.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

enum Route {
    case splash
    case tabBar
    
    var rotingType: RoutingType {
        switch self {
        case .splash, .tabBar:
            return .push
        }
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .splash:
            let viewModel = SplashViewModel()
            let view = SplashView(viewModel: viewModel)
            view
        case .tabBar:
            let view = TabBarView()
            view
        }
    }
}
