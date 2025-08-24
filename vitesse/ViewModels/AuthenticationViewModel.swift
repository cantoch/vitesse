//
//  AuthenticationViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String?
    @Published var isLoggedIn: Bool = false
    
    private let api: APIClient
    private let keychain: KeychainManagerProtocol
    
    init(api: APIClient = DefaultAPIClient(), keychain: KeychainManagerProtocol = KeychainManager.shared) {
        self.api = api
        self.keychain = keychain
    }
    
    @MainActor
    func login() async throws -> AuthResponse {
        let loginData = AuthRequest(email: email, password: password)
        let request = try api.createRequest(
            path: .login,
            method: .post,
            parameters: loginData,
            token: nil
        )
        
        let (data, _) = try await api.fetch(request: request)
        let response: AuthResponse = try api.decode(data: data)
        
        keychain.save(key: "AuthStatus", value: String(response.isAdmin))
        keychain.save(key: "AuthToken", value: response.token)
        isLoggedIn = true
        
        return response
    }
}

