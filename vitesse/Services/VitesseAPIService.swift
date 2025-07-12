//
//  VitesseAPIService.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

struct VitesseAPIService {
    
    //MARK: -Private properties
    private let session: URLSession
    private let baseURLString : String
    
    //MARK: -Initialization
    init(session: URLSession = .shared, baseURLString: String = "http://127.0.0.1:8080") {
        self.session = session
        self.baseURLString = baseURLString
    }
    
    //MARK: -Enumerations
    enum Path: String {
        case login = "/user/auth"
        case register = "/user/register"
        case candidate = "/candidate"
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
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
    
    func createRequest(path: Path, method: Method, parameters: Encodable) throws -> URLRequest {
        var request = URLRequest(url: try createEndpoint(path: path))
        request.httpMethod = method.rawValue
        request.httpBody = try serializeParameters(parameters: parameters)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func fetch(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        print(response)
        
        guard (200...299).contains(response.statusCode) else {
            throw APIError.invalidStatusCode
        }
        return data
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

