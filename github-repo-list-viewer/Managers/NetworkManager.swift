//
//  NetworkManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 14.09.2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(from path: String?) -> AnyPublisher<T, NetworkError>
    func post<T: Decodable, U: Encodable>(to path: String?, body: U) -> AnyPublisher<T, NetworkError>
}

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
    func fetch<T: Decodable>(from path: String?) -> AnyPublisher<T, NetworkError> {
        let fullURL: URL
        
        if let path = path, !path.isEmpty {
            fullURL = baseURL.appendingPathComponent(path)
        } else {
            fullURL = baseURL
        }
        
        guard let url = URL(string: fullURL.absoluteString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        if let apiKey = apiKey {
            request.setValue("Bearer \(apiKey)", 
                             forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        }

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                
                return NetworkError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    func post<T: Decodable, U: Encodable>(to path: String?, body: U) -> AnyPublisher<T, NetworkError> {
        let fullURL: URL
        
        if let path = path, !path.isEmpty {
            fullURL = baseURL.appendingPathComponent(path)
        } else {
            fullURL = baseURL
        }
        
        guard let url = URL(string: fullURL.absoluteString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(MIMEType.JSON.rawValue,
                         forHTTPHeaderField: HTTPHeader.contentType.rawValue)
        
        if let apiKey = apiKey {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: NetworkError.decodingError(error)).eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.serverError(statusCode: httpResponse.statusCode)
                }
                
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                }
                
                return NetworkError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
}
