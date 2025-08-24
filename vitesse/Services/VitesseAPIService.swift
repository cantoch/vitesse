//  VitesseAPIService.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

struct VitesseAPIService: APIClient {
    
    //MARK: -Private properties
    private let session: URLSession
    private let baseURLString : String
    
    //MARK: -Initialization
    init(session: URLSession = .shared, baseURLString: String = "http://127.0.0.1:8080") {
        self.session = session
        self.baseURLString = baseURLString
    }
    
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
    
    func createRequest(path: Path, method: Method, parameters: Encodable? = nil, token: String? = nil) throws -> URLRequest {
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
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            if response.statusCode >= 500 {
                throw APIError.serverError
            }
            throw APIError.invalidStatusCode(response)
        }
        return (data, response)
    }
    
    func decode<T: Decodable>(data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            return response
        }
        catch {
            throw APIError.decodingError
        }
    }
}
