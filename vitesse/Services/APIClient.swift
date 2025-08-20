//
//  APIClient.swift
//  Vitesse
//
//  Created by Renaud Leroy on 13/08/2025.
//


import Foundation

protocol APIClient {
    func createRequest(path: Path,
                       method: Vitesse.Method,
                       parameters: Encodable?,
                       token: String?) throws -> URLRequest
    
    func fetch(request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func decode<T: Decodable>(data: Data) throws -> T
}

struct DefaultAPIClient: APIClient {
    private let service = VitesseAPIService()
    
    func createRequest(path: Path,
                       method: Method,
                       parameters: Encodable?,
                       token: String?) throws -> URLRequest {
        try service.createRequest(path: path, method: method, parameters: parameters, token: token)
    }
    
    func fetch(request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        try await service.fetch(request: request)
    }
    
    func decode<T: Decodable>(data: Data) throws -> T {
        try service.decode(data: data)
    }
}

//MARK: -Enumerations
enum Path {
    case login
    case register
    case candidate
    case favorite(UUID)
    case update(UUID)
    case delete(UUID)
    
    var rawValue: String {
        switch self {
        case .login:
            return "/user/auth"
        case .register:
            return "/user/register"
        case .candidate:
            return "/candidate"
        case .favorite(let id):
            return "/candidate/\(id)/favorite"
        case .update(let id):
            return "/candidate/\(id)"
        case .delete(let id):
            return "/candidate/\(id)"
        }
    }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
 
