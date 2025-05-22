//
//  SplashViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

final class SplashViewModel: ObservableObject {
    @AppStorage(StaticKeys.currentTab.key) private var currentTab: Int = TabBarItems.home.value
    
    func onAppear() {
        showTabBarView()
    }
    
    func onDisappear() {
        LogManager.shared.info("SplashViewModel onDisappear")
    }
    
    func showTabBarView() {
        DispatchQueue.main.async {
            self.currentTab = TabBarItems.home.value
            RouterManager.shared.show(.tabBar, animated: false)
        }
    }
}
