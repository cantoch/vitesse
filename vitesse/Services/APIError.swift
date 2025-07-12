//
//  APIError.swift
//  Vitesse
//
//  Created by Renaud Leroy on 11/07/2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidParameters
    case invalidData
    case invalidResponse
    case invalidStatusCode
    case decodingError
}
