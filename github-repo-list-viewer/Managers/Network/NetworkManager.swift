//
//  NetworkManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 14.09.2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(from path: String?, queryParameters: QueryParameters?) -> AnyPublisher<T, NetworkError>
    func post<T: Decodable, U: Encodable>(to path: String?, body: U, queryParameters: QueryParameters?) -> AnyPublisher<T, NetworkError>
}

typealias QueryParameters = [String: String]

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: Properties
    private let urlSession: URLSession
    private let baseURL: URL
    private var apiKey: String?
    
    // MARK: Init
    init(urlSession: URLSession, baseURL: URL, apiKey: String? = nil) {
        self.urlSession = urlSession
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    
    // MARK: Public Methods
    func fetch<T: Decodable>(from path: String?, queryParameters: QueryParameters? = nil) -> AnyPublisher<T, NetworkError> {
        // Construct the base URL with path
        let baseURLWithPath: URL
        
        if let path = path, !path.isEmpty {
            baseURLWithPath = baseURL.appendingPathComponent(path)
        } else {
            baseURLWithPath = baseURL
        }
        
        // Append query parameters to the URL if any
        let fullURL: URL
        
        if let queryParameters = queryParameters {
            var urlComponents = URLComponents(url: baseURLWithPath, resolvingAgainstBaseURL: false)!
            
            var queryItems = [URLQueryItem]()
            queryParameters.forEach { key, value in
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            fullURL = url
        } else {
            fullURL = baseURLWithPath
        }
        
        // Create the URLRequest
        var request = URLRequest(url: fullURL)
        if let apiKey = apiKey, !apiKey.isEmpty {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }

        // Perform the network request
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return result.data
                case 400...499:
                    throw NetworkError.clientError(statusCode: httpResponse.statusCode)
                case 500...599:
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                default:
                    throw NetworkError.unknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                
                return NetworkError.unknown
            }
            .eraseToAnyPublisher()
    }
    
    func post<T: Decodable, U: Encodable>(to path: String?, body: U, queryParameters: QueryParameters? = nil) -> AnyPublisher<T, NetworkError> {
        // Construct the base URL with path
        let baseURLWithPath: URL
        if let path = path, !path.isEmpty {
            baseURLWithPath = baseURL.appendingPathComponent(path)
        } else {
            baseURLWithPath = baseURL
        }
        
        // Append query parameters to the URL if any
        let fullURL: URL
        if let queryParameters = queryParameters {
            var urlComponents = URLComponents(url: baseURLWithPath, resolvingAgainstBaseURL: false)!
            
            var queryItems = [URLQueryItem]()
            queryParameters.forEach { key, value in
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
            guard let url = urlComponents.url else {
                return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
            }
            fullURL = url
        } else {
            fullURL = baseURLWithPath
        }
        
        // Create the URLRequest
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        
        if let apiKey = apiKey, !apiKey.isEmpty {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: NetworkError.decodingError).eraseToAnyPublisher()
        }
        
        // Perform the network request
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return result.data
                case 400...499:
                    throw NetworkError.clientError(statusCode: httpResponse.statusCode)
                case 500...599:
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                default:
                    throw NetworkError.unknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return NetworkError.unknown
            }
            .eraseToAnyPublisher()
    }
}
