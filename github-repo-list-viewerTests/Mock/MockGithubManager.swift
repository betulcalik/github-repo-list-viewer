//
//  MockGithubManager.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 19.09.2024.
//

import Foundation
import Combine
@testable import github_repo_list_viewer

class MockGithubManager: GithubManagerProtocol {
    
    var getUserResult: Result<GetUserResponseModel, NetworkError>?
    var getUserRepositoriesResult: Result<[GetUserRepositoryResponseModel], NetworkError>?
    
    func getUser(model: GetUserRequestModel) -> AnyPublisher<GetUserResponseModel, NetworkError> {
        if let result = getUserResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Empty().eraseToAnyPublisher()
    }
    
    func getUserRepositories(model: GetUserRepositoryRequestModel) -> AnyPublisher<[GetUserRepositoryResponseModel], NetworkError> {
        if let result = getUserRepositoriesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Empty().eraseToAnyPublisher()
    }
}
