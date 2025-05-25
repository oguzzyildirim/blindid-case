//
//  AuthService.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 23.05.2025.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Auth Service

protocol AuthServiceProtocol {
    func register(name: String, surname: String, email: String, password: String) -> AnyPublisher<AuthResponse, Error>
    func login(email: String, password: String) -> AnyPublisher<AuthResponse, Error>
    func getUserInfo() -> AnyPublisher<CurrentUser, Error>
    func saveToken(_ token: String)
    func getToken() -> String?
    func clearToken()
    func isUserLoggedIn() -> Bool
    func getCurrentLoginState() -> AnyPublisher<LoginState, Never>
    func fetchCurrentUser()
}

final class AuthService: AuthServiceProtocol {
    private let httpClient: HTTPClient
    private let tokenKey = "authToken"
    private let loginStateSubject = CurrentValueSubject<LoginState, Never>(.loggedOut)
    private var cancellables = Set<AnyCancellable>()
    
    @AppStorage(StaticKeys.loginStatus.key) private var isLoggedIn: Bool = false
    
    init(httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
        if let _ = getToken() {
            loginStateSubject.send(.loading)
            fetchCurrentUser()
        }
        
        loginStateSubject
            .sink { [weak self] state in
                self?.isLoggedIn = state.isLoggedIn
            }
            .store(in: &cancellables)
    }
    
    func register(name: String, surname: String, email: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        let request = AuthEndpoint.register(name: name, surname: surname, email: email, password: password).makeRequest
        
        loginStateSubject.send(.loading)
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    let errorMessage = "Registration failed with code: \(response.statusCode)"
                    self.clearToken()
                    self.loginStateSubject.send(.error(errorMessage))
                    throw NSError(domain: "AuthService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                return data
            }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] response in
                guard let self = self else { return }
                self.saveToken(response.token)
                self.fetchCurrentUser()
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.clearToken()
                    self?.loginStateSubject.send(.error(error.localizedDescription))
                }
            })
            .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<AuthResponse, Error> {
        let request = AuthEndpoint.login(email: email, password: password).makeRequest
        
        loginStateSubject.send(.loading)
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    let errorMessage = "Login failed with code: \(response.statusCode)"
                    self.clearToken()
                    self.loginStateSubject.send(.error(errorMessage))
                    throw NSError(domain: "AuthService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                return data
            }
            .decode(type: AuthResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] response in
                guard let self = self else { return }
                self.saveToken(response.token)

                self.fetchCurrentUser()
            }, receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.clearToken()
                    self?.loginStateSubject.send(.error(error.localizedDescription))
                }
            })
            .eraseToAnyPublisher()
    }
    
    func getUserInfo() -> AnyPublisher<CurrentUser, Error> {
        guard let token = getToken() else {
            return Fail(error: NSError(domain: "AuthService", code: 401,
                                       userInfo: [NSLocalizedDescriptionKey: "No token available"]))
                .eraseToAnyPublisher()
        }
        
        let request = AuthEndpoint.me.makeRequest
        
        return httpClient.publisher(request)
            .tryMap { data, response in
                guard 200..<300 ~= response.statusCode else {
                    let errorMessage = "Failed to get user info: \(response.statusCode)"
                    throw NSError(domain: "AuthService", code: response.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                return data
            }
            .decode(type: CurrentUser.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchCurrentUser() {
        guard let token = getToken() else {
            loginStateSubject.send(.loggedOut)
            return
        }
        
        getUserInfo()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    if (error as NSError).code == 401 {
                        self.clearToken()
                    } else {
                        self.loginStateSubject.send(.error(error.localizedDescription))
                    }
                }
            } receiveValue: { [weak self] user in
                self?.loginStateSubject.send(.loggedIn(user))
            }
            .store(in: &cancellables)
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        loginStateSubject.send(.loggedOut)
    }
    
    func isUserLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    func getCurrentLoginState() -> AnyPublisher<LoginState, Never> {
        return loginStateSubject.eraseToAnyPublisher()
    }
}
