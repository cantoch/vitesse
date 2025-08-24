//
//  MockKeychainManager.swift
//  Vitesse
//
//  Created by Renaud Leroy on 21/08/2025.
//


import Foundation
@testable import Vitesse

// MARK: - Mock KeychainManager
class MockKeychainManager: KeychainManagerProtocol {
    var mockToken: [String: String] = [:]
    
    func save(key: String, value: String) {
        mockToken[key] = value
    }
    
    func read(key: String) -> String? {
        return mockToken[key]
    }
    
    func delete(key: String) {
        mockToken.removeValue(forKey: key)
    }
}
