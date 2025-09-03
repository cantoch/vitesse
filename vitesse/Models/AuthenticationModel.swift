//
//  AuthenticationModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

struct AuthRequest: Encodable {
    let email: String
    let password: String
}

struct AuthResponse: Equatable, Decodable {
    let isAdmin: Bool
    let token: String
}

enum AuthError: LocalizedError, Equatable {
    case networkingError
    case invalidCredentials
    case serverError
    case unknown
    
    
    var errorDescription: String? {
        switch self {
        case .networkingError:
            return "Problème de connexion, veuillez vérifier votre connexion internet."
        case .invalidCredentials:
            return "Email ou mot de passe incorrect."
        case .serverError:
            return "Le serveur ne repond pas, réessayez plus tard."
        case .unknown:
            return "Une erreur inconnue est survenue." 
        }
    }
}


