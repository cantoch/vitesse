//
//  CandidateListViewModel 2.swift
//  Vitesse
//
//  Created by Renaud Leroy on 28/07/2025.
//


import Foundation


class CandidateDetailViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    private let keychainManager: KeychainManager
    private let api: APIClient
    
    init(
        keychainManager: KeychainManager = .shared,
        api: APIClient = DefaultAPIClient()) {
            self.keychainManager = keychainManager
            self.api = api
        }
    
    @MainActor
    func favoriteCandidate(candidate: Candidate) async throws {
        guard let token = KeychainManager.shared.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        
        do {
            let request = try api.createRequest(
                path: .favorite(candidate.id),
                method: .post,
                parameters: nil,
                token: token)
            let (data, _) = try await api.fetch(request: request)
            let decodedData: [Candidate] = try api.decode(data: data)
            self.candidates = decodedData
        }
        catch {
            print("Error fetching candidates: \(error)")
        }
    }
}
