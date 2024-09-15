//
//  MockURLProtocol.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 15.09.2024.
//

import Foundation
@testable import github_repo_list_viewer

// Custom URLProtocol for mocking network responses
class MockURLProtocol: URLProtocol {
    static var testURLs: [URL: (Data?, URLResponse?, Error?)] = [:]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let (data, response, error) = MockURLProtocol.testURLs[url] else {
            client?.urlProtocol(self, didFailWithError: NetworkError.invalidURL)
            return
        }
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
