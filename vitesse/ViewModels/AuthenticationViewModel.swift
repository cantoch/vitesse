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
    
    let apiService = VitesseAPIService()
    
    @MainActor
    func login() async throws {
        let loginData = LoginRequest(email: email, password: password)
        let request = try apiService.createRequest(
            path: .login,
            method: .post,
            parameters: loginData)
        let data = try await apiService.fetch(request: request)
        let loginResponse: LoginResponse = try apiService.decode(
            data: data)
        print(loginResponse)
    }
}
