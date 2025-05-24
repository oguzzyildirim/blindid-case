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
    case movieDetail(movieId: Int)
    case login(viewModel: ProfileViewModel? = nil)
    case register(viewModel: ProfileViewModel? = nil)
    case profile
    
    var rotingType: RoutingType {
        switch self {
        case .splash, .tabBar, .movieDetail, .login, .register, .profile:
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
        case .movieDetail(let movieId):
            let view = MovieDetailView(movieId: movieId)
            view
        case .login(let viewModel):
            if let viewModel = viewModel {
                let view = LoginView()
                    .environmentObject(viewModel)
                view
            } else {
                let view = LoginView()
                view
            }
        case .register(let viewModel):
            if let viewModel = viewModel {
                let view = RegisterView()
                    .environmentObject(viewModel)
                view
            } else {
                let view = RegisterView()
                view
            }
        case .profile:
            let view = ProfileView()
            view
        }
    }
}
