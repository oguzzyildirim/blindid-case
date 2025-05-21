//
//  StaticKeys.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation

enum StaticKeys {
    case currentTab
    
    var key: String {
        switch self {
            case .currentTab: return "currentTab"
        }
    }
}
