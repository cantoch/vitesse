//
//  RegistrationViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 10/07/2025.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var errorMessage: String?
    @Published var isRegistered: Bool = false
    
    let apiService = VitesseAPIService()
    
    @MainActor
    func register() async throws {
        let body = RegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        
        guard !email.isEmpty, email.contains("@") else {
            errorMessage = "L'adresse email est invalide"
            return
        }
        
        guard password == passwordConfirmation else {
            errorMessage = "Les 2 mots de passe ne sont pas identiques"
            return
        }
        let request = try apiService.createRequest(path: .register, method: .post, parameters: body)
        let (_, response) = try await apiService.fetch(request: request)
        guard response.statusCode == 201 else {
            errorMessage = "Une erreur est survenue, veuillez réessayer plus tard"
            return
        }
        isRegistered = true
    }
}
