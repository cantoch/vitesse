//
//  CandidateUpdateViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 31/07/2025.
//

import Foundation

class CandidateUpdateViewModel: ObservableObject {
    @Published var candidate: Candidate?
    @Published var email: String = ""
    @Published var note: String = ""
    @Published var linkedinURL: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    
    private let keychainManager: KeychainManager
    private let api: APIClient
    
    init(candidate: Candidate,
         keychainManager: KeychainManager = .shared,
         api: APIClient = DefaultAPIClient()) {
        self.keychainManager = keychainManager
        self.api = api
        self.candidate = candidate
        self.email = candidate.email
        self.note = candidate.note
        self.linkedinURL = candidate.linkedinURL
        self.firstName = candidate.firstName
        self.lastName = candidate.lastName
        self.phone = candidate.phone
    }
    
    @MainActor
    func updateCandidate(candidate: Candidate) async throws {
        guard let token = keychainManager.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        do {
            let body = CandidateRequest(
                email: email,
                note: note,
                linkedinURL: linkedinURL,
                firstName: firstName,
                lastName: lastName,
                phone: phone
            )
            let request = try api.createRequest(
                path: .update(candidate.id),
                method: .put,
                parameters: body,
                token: token
            )
            let (data, _) = try await api.fetch(request: request)
            let updatedCandidate: Candidate = try api.decode(data: data)
            self.candidate = updatedCandidate
        }
    }
}
