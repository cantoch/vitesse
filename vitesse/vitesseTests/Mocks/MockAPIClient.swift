//
//  MockAPIClient.swift
//  VitesseTests
//
//  Created by Renaud Leroy on 13/08/2025.
//

import Foundation
@testable import Vitesse

struct MockAPIClient: APIClient {
    var scenario: MockHTTPScenario
    init(scenario: MockHTTPScenario) {
        self.scenario = scenario
    }
    
    private let session: URLSession = .shared
    private let baseURLString: String = "http://127.0.0.1:8080"
    
    
    //MARK: -Methods
    func createEndpoint(path: Path) throws -> URL {
        guard let url = URL(string: "\(baseURLString)\(path.rawValue)") else {
            throw APIError.invalidURL
        }
        return url
    }
    
    func serializeParameters(parameters: Encodable) throws -> Data {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(parameters) else {
            throw APIError.invalidParameters
        }
        return data
    }
    
    func createRequest(path: Path, method: Vitesse.Method, parameters: Encodable? = nil, token: String? = nil) throws -> URLRequest {
        var request = URLRequest(url: try createEndpoint(path: path))
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            request.httpBody = try serializeParameters(parameters: parameters)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func fetch(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        switch scenario {
        case .successWithoutBody:
            let response = HTTPURLResponse(url: request.url!, statusCode: 204, httpVersion: nil, headerFields: nil)!
            return (Data(), response)
            
        case .successWithBody:
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let jsonData = """
                    {
                        "isAdmin": false,
                        "token": "testToken"
                    }
                    """.data(using: .utf8)!
            return (jsonData, response)
            
        case .candidatesSuccess:
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let candidatesData = """
            [
                {
                    "phone": "123456789",
                    "note": "Test note 1",
                    "id": "550e8400-e29b-41d4-a716-446655440000",
                    "firstName": "John",
                    "linkedinURL": "https://linkedin.com/john",
                    "isFavorite": false,
                    "email": "john@test.com",
                    "lastName": "Doe"
                }
            ]
            """.data(using: .utf8)!
            return (candidatesData, response)
            
        case .serverError:
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            throw APIError.serverError
            
        case .statusCodeError:
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            throw APIError.invalidStatusCode(response)
            
        case .networkError:
            throw URLError(.notConnectedToInternet)
            
        case .emptyData:
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"])!
            return (Data(), response)
            
        case .invalidURL:
            throw URLError(.badURL)
        }
    }
    
    func decode<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        }
        catch {
            throw APIError.decodingError
        }
    }
    
    final class MockKeychainManager: KeychainManagerProtocol {
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
}



