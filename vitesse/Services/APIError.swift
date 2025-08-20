//
//  APIError.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case invalidParameters
    case invalidData
    case invalidResponse
    case invalidStatusCode(HTTPURLResponse)
    case serverError(HTTPURLResponse)
    case decodingError
}
