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
