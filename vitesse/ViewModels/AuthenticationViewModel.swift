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
    
    let apiService = VitesseAPIService()
    
    @MainActor
    func login() async throws {
        let loginData = AuthRequest(email: email, password: password)
        let request = try apiService.createRequest(
            path: .login,
            method: .post,
            parameters: loginData)
        
        let (data, _) = try await apiService.fetch(request: request)
        let response: AuthResponse = try apiService.decode(data: data)
        
        KeychainManager.shared.save(key: "AuthStatus", value: String(response.isAdmin))
        KeychainManager.shared.save(key: "AuthToken", value: response.token)
        isLoggedIn = true
    }
}
