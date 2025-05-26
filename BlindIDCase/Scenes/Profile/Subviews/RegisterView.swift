//
//  RegisterView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import SwiftUI
import Combine

struct RegisterView: View {
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        ZStack {
            Color(.appMain)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerText
                    
                    RegisterForm(
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
                        title: LoginViewStrings.register.value,
                        action: viewModel.register,
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.isRegisterFormValid
                    )
                    .padding(.top, 8)
                    
                    loginPrompt
                }
                .padding(.horizontal, 24)
                .padding(.top, 80)
            }
            BaseNavigationBar(navigationTitle: "Register")
                .environmentObject(router)
//            CustomNavigationBar.standard(title: "Register")
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
private extension RegisterView {
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
    
    var loginPrompt: some View {
        HStack(spacing: 4) {
            Text(LoginViewStrings.registerQuestion.value)
                .foregroundColor(.gray)
                .font(.system(size: 14))
            
            Button {
                router.pop(animated: true)
            } label: {
                Text(LoginViewStrings.login.value)
                    .foregroundColor(.blue)
                    .font(.system(size: 14, weight: .semibold))
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    RegisterView()
        .environmentObject(ProfileViewModel())
} 
