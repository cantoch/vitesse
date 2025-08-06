//
//  CandidateCreationViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 05/08/2025.
//

import Foundation

class CandidateCreationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var note: String = ""
    @Published var linkedinURL: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    
    private let keychainManager: KeychainManager
    private let apiService: VitesseAPIService
    
    init(candidate: CandidateRequest, keychainManager: KeychainManager = .shared, apiService: VitesseAPIService = VitesseAPIService()) {
        self.keychainManager = keychainManager
        self.apiService = apiService
        self.email = candidate.email
        self.note = candidate.note
        self.linkedinURL = candidate.linkedinURL
        self.firstName = candidate.firstName
        self.lastName = candidate.lastName
        self.phone = candidate.phone
    }
    
    @MainActor
    func addCandidate() async throws {
        guard let token = keychainManager.read(key: "Authtoken") else {
            fatalError("No token found in keychain")
        }
        do {
            let body = CandidateRequest(email: email, note: note, linkedinURL: linkedinURL, firstName: firstName, lastName: lastName, phone: phone)
            let request = try apiService.createRequest(
                path: .candidate,
                method: .post,
                parameters: body,
                token: token)
            let (data, _) = try await apiService.fetch(request: request)
            _ = try JSONDecoder().decode(Candidate.self, from: data)
        }
    }
}
