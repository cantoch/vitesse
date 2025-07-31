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
    private let apiService: VitesseAPIService
    
    init(
        keychainManager: KeychainManager = .shared,
        apiService: VitesseAPIService = VitesseAPIService()
    ) {
        self.keychainManager = keychainManager
        self.apiService = apiService
    }
    
    @MainActor
    func favoriteCandidate(candidate: Candidate) async throws {
        guard let token = KeychainManager.shared.read(key: "Authtoken") else {
            fatalError("No token found in keychain")
        }
        
        do {
            let request = try apiService.createRequest(
                path: .favorite(candidate.id),
                method: .post,
                token: token)
            let (data, _) = try await apiService.fetch(request: request)
            let decodedData = try JSONDecoder().decode([Candidate].self, from: data)
            self.candidates = decodedData
        }
        catch {
            print("Error fetching candidates: \(error)")
        }
    }
}
