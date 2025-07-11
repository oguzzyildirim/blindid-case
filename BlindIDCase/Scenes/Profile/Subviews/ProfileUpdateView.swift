//
//  ProfileUpdateView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 26.05.2025.
//

import Combine
import SwiftUI

struct ProfileUpdateView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject var router: RouterManager

    var body: some View {
        ZStack {
            Color(.appMain)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerText

                    ProfileUpdateForm(
                        firstName: $viewModel.firstName,
                        lastName: $viewModel.lastName,
                        email: $viewModel.email,
                        password: $viewModel.password
                    )

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.top, 8)
                    }

                    PrimaryButton(
                        title: LoginViewStrings.updateProfile.value,
                        action: viewModel.update,
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.isRegisterFormValid
                    )
                    .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
            }
            BaseNavigationBar(navigationTitle: "Profile")
                .environmentObject(router)

//            CustomNavigationBar.standard(title: "Update")
//                .environmentObject(router)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.clearFormValues()
            viewModel.router = router
        }
    }
}

// MARK: - Private UI Components

private extension ProfileUpdateView {
    var headerText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LoginViewStrings.header.value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text(LoginViewStrings.subText.value)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 16)
    }
}

#Preview {
    ProfileUpdateView()
        .environmentObject(ProfileViewModel())
}
