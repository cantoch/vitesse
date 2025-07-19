//
//  CandidateModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import Foundation

struct Candidate: Identifiable {
    let phone: Int
    let note: String
    let id: UUID
    let firstName: String
    let linkedinURL: String
    let isFavorite: Bool
    let email: String
    let lastName: String
}
