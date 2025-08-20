//
//  MockHTTPScenario.swift
//  VitesseTests
//
//  Created by Renaud Leroy on 13/08/2025.
//

import Foundation

enum MockHTTPScenario {
    case successWithoutBody
    case successWithBody
    case serverError
    case statusCodeError
    case networkError
    case emptyData
}

struct MockResponseProvider {
    func makeMock(for scenario: MockHTTPScenario) -> (URLResponse?, Data?, Error?) {
        switch scenario {
        case .successWithoutBody:
            let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!,
                                           statusCode: 204,
                                           httpVersion: nil,
                                           headerFields: nil)!
            let data = Data()
            
            MockURLProtocol.requestHandler = { request in
                return (response, data, nil)
            }
            return (response, data, nil)
            
        case .successWithBody:
            let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            let data = """
          {
           "nom prenom": "text"
          }
          """.data(using: .utf8)!
            
            MockURLProtocol.requestHandler = { request in
                return (response, data, nil)
            }
            return (response, data, nil)
            
            
        case .serverError:
            let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
            let data = """
        { 
        "error": "Internal Server Error" 
        }
        """.data(using: .utf8)!
            
            MockURLProtocol.requestHandler = { request in
                return (response, data, nil)
            }
            return (response, data, nil)
            
        case .statusCodeError:
            let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!,
                                           statusCode: 400,
                                           httpVersion: nil,
                                           headerFields: nil)!
       
            MockURLProtocol.requestHandler = { request in
                return (response, Data(), nil)
            }
            return (response, Data(), nil)
            
            
        case .networkError:
            let error = URLError(.notConnectedToInternet)
            MockURLProtocol.requestHandler = { request in
                return (nil, nil, error)
            }
            return (nil, nil, error)
            
            
        case .emptyData:
            let response = HTTPURLResponse(url: URL(string: "http://127.0.0.1:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            MockURLProtocol.requestHandler = { request in
                return (response, Data(), nil)
            }
            return (response, Data(), nil)
        }
    }
}
