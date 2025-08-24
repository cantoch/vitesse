//
//  APIClientTests.swift
//  VitesseTests
//
//  Created by Renaud Leroy on 19/08/2025.
//

import XCTest
@testable import Vitesse

final class APIClientTests: XCTestCase {
    var session = URLSession(configuration: .ephemeral)
    let mockResponseProvider = MockResponseProvider()
    var api: VitesseAPIService!
    
    override func setUpWithError() throws {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)
        api = VitesseAPIService(session: session)
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        MockURLProtocol.requestHandler = nil
        api = nil
    }
    
    private struct FailingEncodable: Encodable {
        func encode(to encoder: Encoder) throws {
            throw EncodingError.invalidValue("", EncodingError.Context(codingPath: [], debugDescription: "Forced Encoding failure"))
        }
    }
    
    func testCreateEndpoint() throws {
        do {
            let url = try api.createEndpoint(path: .login)
            XCTAssertEqual(url.absoluteString, "http://127.0.0.1:8080/user/auth")
        }
        catch {
            XCTFail("Unexpected error: \(APIError.invalidURL)")
        }
    }
    
    func testCreateEndpointWithCustomBaseURL() throws {
        // Given
        let api = VitesseAPIService(session: session, baseURLString: "https://example.com")
        
        // When / Then
        XCTAssertEqual(try api.createEndpoint(path: .login).absoluteString, "https://example.com/user/auth")
    }
    
    func testSerializeParameters() throws {
        // Given
        let parameters: [String: Any] = ["key": "value"]
        
        // When
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        let serializedParameters = String(data: data, encoding: .utf8)
        
        // Then
        XCTAssertEqual(serializedParameters, "{\"key\":\"value\"}")
    }
    
    func testSerializeParametersThrowsError() throws {
        let parameters = FailingEncodable()
        
        XCTAssertThrowsError(try api.serializeParameters(parameters: parameters)) { error in
            XCTAssertEqual(error as? APIError, .invalidParameters)
        }
    }
    
    func testCreateRequestSuccessWithoutBody() throws {
        // Given
        let url = URL(string: "http://127.0.0.1:8080/user/auth")!
        let data: Data? = nil
        let method: Vitesse.Method = .get
        
        // When
        let request = try api.createRequest(path: .login, method: method)
        
        // Then
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.httpBody, data)
    }
    
    func testCreateRequestSuccessWithBody() throws {
        // Given
        let expectedURL = URL(string: "http://127.0.0.1:8080/user/register")!
        let parameters: Encodable = ["key": "value"]
        let body = try api.serializeParameters(parameters: parameters)
        let method: Vitesse.Method = .post
        let token: String? = "token"
        
        // When
        let request = try api.createRequest(path: .register, method: method, parameters: parameters, token: token)
        
        // Then
        XCTAssertEqual(request.url, expectedURL)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNotNil(request.httpBody)
        XCTAssertEqual(request.httpBody!, body)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer token")
    }
    
    func testCreateRequestFailureWithInvalidParameters() throws {
        // Given
        let method: Vitesse.Method = .get
        let parameters = FailingEncodable()
        
        // When / Then
        XCTAssertThrowsError(try api.createRequest(path: .login, method: method, parameters: parameters, token: nil)) { error in XCTAssertEqual(error as? APIError, .invalidParameters)
        }
    }
    
    func testCreateRequestFailureWithInvalidURL() throws {
        // Given
        let badAPI = VitesseAPIService(session: session, baseURLString: " http://invalid url.com")
        
        // When / Then
        XCTAssertThrowsError(try badAPI.createRequest(path: .login, method: .get)) { error in XCTAssertEqual(error as? APIError, .invalidURL)
        }
    }
    
    func testCreateRequestWithoutBodyWithoutContentTypeHeader() throws {
        let request = try api.createRequest(path: .login, method: .get, parameters: nil, token: nil)
        XCTAssertNil(request.value(forHTTPHeaderField: "Content-Type"))
        XCTAssertNil(request.httpBody)
    }
    
    func testCreateRequestWithBodyWithoutContentTypeHeader() throws {
        // Given
        let parameters: Encodable = ["key": "value"]
        
        // When
        let request = try api.createRequest(path: .login, method: .get, parameters: parameters, token: nil)
        
        // Then
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertNotNil(request.httpBody)
    }
    
    func testFetchDataSuccess() async throws {
        let (_, mockExpectedData, _) = mockResponseProvider.makeMock(for: .successWithBody)
        let expectedData = try XCTUnwrap(mockExpectedData)
        let request = try api.createRequest(path: .login, method: .get)
        let (data, _) = try await api.fetch(request: request)
        
        XCTAssertEqual(data, expectedData)
    }
    
    func testFetchDataFailureWithInvalidURL() async throws {
        // Given
        _ = mockResponseProvider.makeMock(for: .invalidURL)
        let request = try api.createRequest(path: .login, method: .get)
        
        // When / Then
        do {
            _ = try await api.fetch(request: request)
        } catch {
            let urlError = error as! URLError
            XCTAssertEqual(urlError.code, .badURL)
        }
    }
    
    func testFetchDataFailureWithNoData() async throws {
        // Given
        _ = mockResponseProvider.makeMock(for: .emptyData)
        let request = try api.createRequest(path: .login, method: .get)
        
        // When / Then
        do {
            _ = try await api.fetch(request: request)
        } catch {
            XCTAssertEqual(error as? APIError, .emptyData)
        }
    }
    
    func testFetchDataWithNetworkError() async throws {
        // Given
        _ = mockResponseProvider.makeMock(for: .networkError)
        let request = try api.createRequest(path: .login, method: .get)
        
        // When / Then
        do {
            _ = try await api.fetch(request: request)
        } catch {
            let urlError = error as! URLError
            XCTAssertEqual(urlError.code, .notConnectedToInternet)
        }
    }
    
    func testFetchWithServerError() async throws {
        // Given
        _ = mockResponseProvider.makeMock(for: .serverError)
        let request = try api.createRequest(path: .login, method: .get)
        
        // When / Then
        do {
            _ = try await api.fetch(request: request)
        } catch {
            XCTAssertEqual(error as? APIError, .serverError)
        }
    }
    
    func testDecodeSuccess() throws {
        // Given
        let jsonData = """
          { "isAdmin": false, "token": "abc123" }
        """.data(using: .utf8)!
        
        // When
        let result: AuthResponse = try api.decode(data: jsonData)
        
        // Then
        XCTAssertEqual(result, AuthResponse(isAdmin: false, token: "abc123"))
    }
    
    func testDecodeFailureWithIncorrectJSON() throws {
        // Given
        let incorrectJSON = "".data(using: .utf8)!
        
        // When / Then
        XCTAssertThrowsError(try { let _: AuthResponse = try self.api.decode(data: incorrectJSON) }()) { error in
            XCTAssertEqual(error as? APIError, .decodingError)
        }
    }
}
