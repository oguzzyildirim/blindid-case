//
//  TabBarView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage(StaticKeys.currentTab.key) private var currentTab: Int = TabBarItems.home.value

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(TabBarItems.home.value)

                FavoritesView()
                    .tag(TabBarItems.favorites.value)

                ProfileView()
                    .tag(TabBarItems.profile.value)
            }
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
            BlindIDCaseTabView()
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarHidden(true)
    }
}

#Preview {
    TabBarView()
}
