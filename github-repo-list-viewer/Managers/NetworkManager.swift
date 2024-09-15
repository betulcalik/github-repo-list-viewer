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
    
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetch<T>(from path: String? = nil) -> AnyPublisher<T, NetworkError> where T: Decodable {
        let fullURL: URL
        
        if let path = path, !path.isEmpty {
            fullURL = baseURL.appendingPathComponent(path)
        } else {
            fullURL = baseURL
        }
        
        guard let url = URL(string: fullURL.absoluteString) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
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
    
    func post<T, U>(to path: String? = nil, body: U) -> AnyPublisher<T, NetworkError> where T: Decodable, U: Encodable {
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
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: NetworkError.decodingError(error)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
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
