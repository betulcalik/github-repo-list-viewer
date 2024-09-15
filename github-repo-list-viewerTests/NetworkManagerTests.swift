//
//  NetworkManagerTests.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 15.09.2024.
//

import XCTest
import Combine
@testable import github_repo_list_viewer

/// This is a sample test class for the NetworkManager, using JSONPlaceholder as the mock API.
final class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(urlSession: urlSession, baseURL: URL(string: "https://jsonplaceholder.typicode.com")!)
    }
    
    override func tearDown() {
        networkManager = nil
        MockURLProtocol.testURLs.removeAll()
        
        super.tearDown()
    }
    
    func testFetchSuccess() {
        let mockData = """
            {
                "userId": 1,
                "id": 1,
                "title": "Test Title",
                "body": "Test Body"
            }
            """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/posts/1")!,
                                           statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.testURLs[URL(string: "https://jsonplaceholder.typicode.com/posts/1")!] = (mockData, mockResponse, nil)
        
        struct Post: Decodable, Equatable {
            let userId: Int
            let id: Int
            let title: String
            let body: String
        }
        
        let expectedPost = Post(userId: 1, 
                                id: 1,
                                title: "Test Title",
                                body: "Test Body")
        
        let expectation = self.expectation(description: "API Fetch Success")
        
        networkManager.fetch(from: "posts/1")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { (post: Post) in
                XCTAssertEqual(post, expectedPost)
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testPostSuccess() {
        let mockData = """
            {
                "id": 1
            }
            """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!,
                                           statusCode: 201, httpVersion: nil, headerFields: nil)
        MockURLProtocol.testURLs[URL(string: "https://jsonplaceholder.typicode.com/posts")!] = (mockData, mockResponse, nil)
        
        struct PostResponse: Decodable, Equatable {
            let id: Int
        }
        
        let expectedResponse = PostResponse(id: 1)
        
        let postBody = ["title": "New Post",
                        "body": "This is a new post"]
        
        let expectation = self.expectation(description: "Post success")
        
        networkManager.post(to: "posts", body: postBody)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got error: \(error)")
                }
            }, receiveValue: { (response: PostResponse) in
                XCTAssertEqual(response, expectedResponse)
                
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
}
