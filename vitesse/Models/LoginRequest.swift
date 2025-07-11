//
//  AuthenticationModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String
    let isAdmin: Bool
}
