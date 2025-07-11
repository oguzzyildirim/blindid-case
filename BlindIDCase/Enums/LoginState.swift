//
//  LoginState.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 24.05.2025.
//

import Foundation

// MARK: - Authentication State

enum LoginState {
    case loggedIn(CurrentUser)
    case loggedOut
    case loading
    case error(String)

    var isLoggedIn: Bool {
        if case .loggedIn = self {
            return true
        }
        return false
    }

    var user: CurrentUser? {
        if case let .loggedIn(user) = self {
            return user
        }
        return nil
    }

    var errorMessage: String? {
        if case let .error(message) = self {
            return message
        }
        return nil
    }
}
