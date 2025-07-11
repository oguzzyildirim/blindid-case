//
//  BlindIDCaseTabView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI

struct BlindIDCaseTabView: View {
    @AppStorage(StaticKeys.currentTab.key) private var currentTab: Int = TabBarItems.home.value

    var body: some View {
        HStack(alignment: .top) {
            TabButton(isFocused: currentTab == TabBarItems.home.value,
                      tabImage: .homeIcon,
                      title: TabBarItems.home.label)
            {
                currentTab = TabBarItems.home.value
            }

            TabButton(isFocused: currentTab == TabBarItems.favorites.value,
                      tabImage: .favoritesIcon,
                      title: TabBarItems.favorites.label)
            {
                currentTab = TabBarItems.favorites.value
            }

            TabButton(isFocused: currentTab == TabBarItems.profile.value,
                      tabImage: .profileIcon,
                      title: TabBarItems.profile.label)
            {
                currentTab = TabBarItems.profile.value
            }
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
        .background(Color(.appMain))
        .onChange(of: currentTab) { _ in
        }
    }
}

struct TabButton: View {
    let isFocused: Bool
    let tabImage: ImageResource
    let title: String
    let tapAction: () -> Void

    var body: some View {
        Button(action: tapAction, label: {
            VStack {
                ZStack {
                    Image(tabImage)
                        .resizable()
                        .foregroundStyle(isFocused ? .blue : .gray)
                }
                .frame(width: 24, height: 24)

                Text(title)
                    .font(isFocused ? .robotoBold(size: 10) : .robotoMedium(size: 10))
                    .foregroundStyle(isFocused ? .blue : .gray)
            }
        })
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BlindIDCaseTabView()
}
