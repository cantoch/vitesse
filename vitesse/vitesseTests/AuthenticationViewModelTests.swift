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
    var mockApi: MockAPIClient!
    var mockKeychain: MockKeychainManager!
    
    override func setUpWithError() throws {
        mockKeychain = MockKeychainManager()
    }
    
    override func tearDownWithError() throws {
        mockKeychain = nil
        viewModel = nil
    }
    
    func testLoginSuccessWithBody() async throws {
        mockApi = MockAPIClient(scenario: .successWithBody)
        viewModel = AuthenticationViewModel(api: mockApi, keychain: mockKeychain)
        viewModel.email = "test@test.com"
        viewModel.password = "test"
        
        let response = try await viewModel.login()
        
        XCTAssertEqual(response.token, "testToken")
    }
}
