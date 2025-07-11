//
//  StaticKeys.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation

enum StaticKeys {
    case currentTab
    case loginStatus

    var key: String {
        switch self {
        case .currentTab: return "currentTab"
        case .loginStatus: return "loginStatus"
        }
    }
}
