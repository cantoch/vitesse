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
        case login = "/auth"
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
    
    func serializeParameters(parameters: [String: Any]) throws -> Data? {
        guard JSONSerialization.isValidJSONObject(parameters) else {
            throw APIError.invalidParameters
        }
        return try JSONSerialization.data(withJSONObject: parameters)
    }
    
    func createRequest(path: Path, method: Method, parameters: Data?) throws -> URLRequest {
        var request = URLRequest(url: try createEndpoint(path: path))
        request.httpMethod = method.rawValue
        if let parameters = parameters {
            request.httpBody = parameters
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
