//
//  TabBarItems.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation

enum TabBarItems {
    case home
    case favorites
    case profile
    
    var value: Int {
        switch self {
        case .home:
            return 0
        case .favorites:
            return 1
        case .profile:
            return 2
        }
    }
    
    var label: String {
        switch self {
        case .home:
            return "Home"
        case .favorites:
            return "Favorites"
        case .profile:
            return "Profile"
        }
    }
}
