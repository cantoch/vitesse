//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import Foundation


class CandidateListViewModel: ObservableObject {
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
    func getAllCandidates() async throws {
        guard let token = KeychainManager.shared.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        do {
            let request = try apiService.createRequest(
                path: .candidate,
                method: .get,
                token: token)
            let (data, _) = try await apiService.fetch(request: request)
            let decodedData : [Candidate] = try JSONDecoder().decode([Candidate].self, from: data)
            self.candidates = decodedData
        }
        catch {
            print("Error fetching candidates: \(error)")
        }
    }
    
    func deleteCandidateFromServer(candidate: Candidate) async throws {
        guard let token = KeychainManager.shared.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        do {
            let request = try apiService.createRequest(
                path: .delete(candidate.id),
                method: .delete,
                token: token)
            let (_, response) = try await apiService.fetch(request: request)
            guard response.statusCode == 200 else {
                return
            }
        }
        catch {
            print("Error fetching candidates: \(error)")
        }
    }
   
    @MainActor
    func deleteCandidate(at offsets: IndexSet) async {
        let candidatesToDelete = offsets.map { self.candidates[$0] }
        for candidate in candidatesToDelete {
            do {
                try await deleteCandidateFromServer(candidate: candidate)
                self.candidates.removeAll(where: { $0.id == candidate.id })
            }
            catch {
                print("Error deleting candidate: \(error)")
            }
        }
    }
}


