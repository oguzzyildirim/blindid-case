//
//  ProfileViewModel.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var loginState: LoginState = .loggedOut
    @Published var currentUser: CurrentUser?
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var isLoginFormValid: Bool {
        return email.isValidEmail() && !password.isEmpty
    }
    
    var isRegisterFormValid: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && email.isValidEmail() && password.count >= 6
    }
    
    var router: RouterManager?
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService

        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        authService.getCurrentLoginState()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                self.loginState = state
                
                if case .loggedIn(let user) = state {
                    self.currentUser = user
                } else {
                    self.currentUser = nil
                }
            }
            .store(in: &cancellables)
    }
    
    func login() {
        guard isLoginFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.authService.fetchCurrentUser()
            }
            .store(in: &cancellables)
    }
    
    func register() {
        guard isRegisterFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        authService.register(name: firstName, surname: lastName, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.setupSubscriptions()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.router?.pop(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func update() {
        guard isRegisterFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        authService.update(name: firstName, surname: lastName, email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.setupSubscriptions()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.router?.pop(animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func getUserInfo() {
        authService.fetchCurrentUser()
    }
    
    func logout() {
        authService.clearToken()
    }

    func clearFormValues() {
        email = ""
        password = ""
        firstName = ""
        lastName = ""
        errorMessage = nil
    }
}
