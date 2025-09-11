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
    @Published var errorMessage: AuthError?
    @Published var isLoggedIn: Bool = false
    
    
    private let api: APIClient
    private let keychain: KeychainManagerProtocol
    
    init(api: APIClient = DefaultAPIClient(), keychain: KeychainManagerProtocol = KeychainManager.shared) {
        self.api = api
        self.keychain = keychain
    }
    
    @MainActor
    func login() async {
        let loginData = AuthRequest(email: email, password: password)
        do {
            let request = try api.createRequest(
                path: .login,
                method: .post,
                parameters: loginData,
                token: nil
            )
            
            let (data, response) = try await api.fetch(request: request)
            
            switch response.statusCode {
            case 200..<300:
                let authResponse: AuthResponse = try api.decode(data: data)
                keychain.save(key: "AuthStatus", value: String(authResponse.isAdmin))
                keychain.save(key: "AuthToken", value: authResponse.token)
                isLoggedIn = true
                errorMessage = nil
                
            case 401:
                errorMessage = .invalidCredentials
                isLoggedIn = false
                
            case 500...600:
                errorMessage = .serverError
                isLoggedIn = false
                
            default:
                errorMessage = .unknown
                isLoggedIn = false
            }
        }
        catch {
            errorMessage = .unknown
            isLoggedIn = false
        }
    }
}
