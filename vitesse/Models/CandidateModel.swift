//
//  CandidateModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import Foundation

struct Candidate: Encodable, Decodable, Identifiable {
    let phone: String
    let note: String
    let id: UUID
    let firstName: String
    let linkedinURL: String
    let isFavorite: Bool
    let email: String
    let lastName: String
}

struct CandidateRequest: Encodable {
    let email: String
    let note: String?
    let linkedinURL: String?
    let firstName: String
    let lastName: String
    let phone: String
}
