//
//  NetworkError.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 14.09.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid_url".localized()
        case .invalidResponse:
            return "invalid_server_response".localized()
        case .serverError(let statusCode):
            return "server_error".localized(with: statusCode)
        case .decodingError:
            return "failed_data_decode".localized()
        case .unknown:
            return "unknown_error".localized()
        }
    }
}

