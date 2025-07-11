//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 10/07/2025.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var errorMessage: String?
    
    @MainActor
    func register() {
        let apiService = VitesseAPIService()
        let body = RegisterRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        
        guard !email.isEmpty, email.contains("@") else {
            errorMessage = "L'adresse email est invalide"
            return
        }
        
        guard password == passwordConfirmation else {
            errorMessage = "Les 2 mots de passe ne sont pas identiques"
            return
        }
        
        _ = try? apiService.createRequest(path: .register, method: .post, parameters: try JSONEncoder().encode(body))
         
        do {
            
        }
    }
}
