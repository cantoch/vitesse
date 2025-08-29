//
//  CandidateListViewModelTests.swift
//  VitesseTests
//
//  Created by Renaud Leroy on 19/08/2025.
//

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var viewModel: CandidateListViewModel!
    var mockApi: MockAPIClient!
    var mockKeychain: MockKeychainManager!
    
    override func setUpWithError() throws {
        mockKeychain = .init()
    }
    
    override func tearDownWithError() throws {
        mockKeychain = nil
        viewModel = nil
    }
    
    func testGetAllCandidatesSuccess() async throws {
        // Given
        mockKeychain.mockToken = ["AuthToken": "test"]
        mockApi = MockAPIClient(scenario: .candidatesSuccess)
        viewModel = CandidateListViewModel(api: mockApi, keychain: mockKeychain)

        // When
        try await viewModel.getAllCandidates()
        
        // Then
        XCTAssertFalse(viewModel.candidates.isEmpty)
        XCTAssert(viewModel.candidates.count == 1)
    }
    
    func testGetAllCandidatesFailure() async throws {
        // Given
        mockKeychain.mockToken = ["AuthToken": "test"]
        mockApi = MockAPIClient(scenario: .networkError)
        viewModel = CandidateListViewModel(api: mockApi, keychain: mockKeychain)
        
        // When
        try await viewModel.getAllCandidates()
        
        // Then
        XCTAssertTrue(viewModel.candidates.isEmpty)
    }
    
    func testDeleteCandidateFromServerSuccess() async throws {
        // Given
        mockKeychain.mockToken = ["AuthToken": "test"]
        mockApi = MockAPIClient(scenario: .successWithBody)
        viewModel = CandidateListViewModel(api: mockApi, keychain: mockKeychain)
        
        // When
    }
}

