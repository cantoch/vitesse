//
//  Candidate.swift
//  Vitesse
//
//  Created by Renaud Leroy on 10/07/2025.
//

import Foundation

struct RegistrationRequest: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
