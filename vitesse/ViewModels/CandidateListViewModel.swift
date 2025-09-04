//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by Renaud Leroy on 19/07/2025.
//

import Foundation


class CandidateListViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
   
    private let api: APIClient
    private let keychain: KeychainManagerProtocol
    
    init(api: APIClient = DefaultAPIClient(), keychain: KeychainManagerProtocol = KeychainManager.shared) {
        self.api = api
        self.keychain = keychain
    }
    
    @MainActor
    func getAllCandidates() async throws {
        guard let token = keychain.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        do {
            let request = try api.createRequest(
                path: .candidate,
                method: .get,
                parameters: nil,
                token: token)
            let (data, _) = try await api.fetch(request: request)
            let decodedData : [Candidate] = try api.decode(data: data)
            self.candidates = decodedData
        }
        catch {
            print("Error fetching candidates: \(error)")
        }
    }
    
    @MainActor
    func deleteCandidateFromServer(candidate: Candidate) async throws {
        guard let token = KeychainManager.shared.read(key: "AuthToken") else {
            fatalError("No token found in keychain")
        }
        do {
            let request = try api.createRequest(
                path: .delete(candidate.id),
                method: .delete,
                parameters: nil,
                token: token)
            let (_, response) = try await api.fetch(request: request)
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
    
    @MainActor
    func deleteCandidates(ids: Set<UUID>) async {
        let candidatesToDelete = candidates.filter { ids.contains($0.id) }
        for candidate in candidatesToDelete {
            do {
                try await deleteCandidateFromServer(candidate: candidate)
                candidates.removeAll { $0.id == candidate.id }
            } catch {
                print("Error deleting candidate: \(error)")
            }
        }
    }
}


