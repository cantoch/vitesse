//
//  AuthenticationViewModelTests.swift
//  VitesseTests
//
//  Created by Renaud Leroy on 15/08/2025.
//

import XCTest
@testable import Vitesse

final class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var api: MockAPIClient!
    var keychain: MockKeychainManager!
    
    override func setUpWithError() throws {
        keychain = MockKeychainManager()
        viewModel = AuthenticationViewModel()
    }
    
    override func tearDownWithError() throws {
        keychain = nil
        viewModel = nil
    }
    
    func testLoginSuccessWithoutBody() async throws {
        let api = MockAPIClient(scenario: .successWithoutBody)
        let request = try api.createRequest(path: .login, method: .post)
        
        let (data, response) = try await api.fetch(request: request)
        
        XCTAssert(response.statusCode == 204)
        XCTAssertTrue(data.isEmpty)
    }
}

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
