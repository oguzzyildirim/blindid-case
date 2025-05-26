//
//  ProfileView.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var router: RouterManager
    
    var body: some View {
        ZStack {
            Color(.appMain)
                .ignoresSafeArea()
            
            switch viewModel.loginState {
            case .loggedIn:
                loggedInView
                    .onAppear {
                        viewModel.getUserInfo()
                    }
            case .loading:
                loadingView
            case .error(let message):
                errorView(message: message)
            case .loggedOut:
                LoginView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    private var loggedInView: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let user = viewModel.currentUser {
                    UserInfo(user: user)
                }
                settingsSection
            }
            .padding()
        }
        .navigationTitle(LoginViewStrings.profile.value)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.logout) {
                    Text(LoginViewStrings.logout.value)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text(LoginViewStrings.error.value)
                .font(.title)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(LoginViewStrings.tryAgain.value) {
                viewModel.loginState = .loggedOut
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LoginViewStrings.settings.value)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 16)
            
            VStack {
                Button {
                    router.show(.updateProfile(viewModel: viewModel), animated: true)
                } label: {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.blue)
                        Text(LoginViewStrings.updateProfile.value)
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                Button {
                    viewModel.logout()
                } label: {
                    HStack {
                        Image(systemName: "arrow.right.square")
                            .foregroundColor(.red)
                        Text(LoginViewStrings.logout.value)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding()
                }
            }
            .background(Color.black.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

#Preview {
    ProfileView()
}
