//
//  LoginView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Combine
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject var router: RouterManager

    var body: some View {
        ZStack {
            Color(.appMain)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    headerText

                    VStack(spacing: 16) {
                        CustomTextField(
                            text: $viewModel.email,
                            placeholder: LoginViewStrings.emailHolder.value,
                            floatingText: LoginViewStrings.email.value,
                            isEmail: true
                        )

                        CustomTextField(
                            text: $viewModel.password,
                            placeholder: LoginViewStrings.passwordHolder.value,
                            floatingText: LoginViewStrings.password.value,
                            isPassword: true
                        )
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.top, 8)
                    }

                    Button(action: viewModel.login) {
                        Text(LoginViewStrings.login.value)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isLoginFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.isLoginFormValid || viewModel.isLoading)
                    .padding(.top, 8)

                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.top, 16)
                    }

                    registerPrompt
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.clearFormValues()
            viewModel.router = router
        }
    }
}

// MARK: - Private UI Components

private extension LoginView {
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

    var registerPrompt: some View {
        HStack(spacing: 4) {
            Text(LoginViewStrings.registerQuestion.value)
                .foregroundColor(.gray)
                .font(.system(size: 14))

            Button {
                router.show(.register(viewModel: viewModel), animated: true)
            } label: {
                Text(LoginViewStrings.register.value)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    LoginView()
        .environmentObject(ProfileViewModel())
}
