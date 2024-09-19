//
//  MockGithubDataModelManager.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 19.09.2024.
//

import Foundation
import Combine
import CoreData
@testable import github_repo_list_viewer

class MockGithubDataModelManager: GithubDataModelManagerProtocol {
    var saveUserResult: Result<User, Error>?
    var fetchAllUsersResult: Result<[User], Error>?
    var saveRepositoriesResult: Result<Void, Error>?
    var fetchAllRepositoriesResult: Result<[Repository], Error>?
    var fetchUserRepositoriesResult: Result<[Repository], Error>?
    
    private let coreDataManager: CoreDataManagerProtocol
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func saveUser(model: GetUserResponseModel) -> AnyPublisher<User, Error> {
        if let result = saveUserResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func saveRepository(user: User, model: GetUserRepositoryResponseModel) {
        
    }
    
    func saveRepositories(user: User, models: [GetUserRepositoryResponseModel]) {
        
    }
    
    func fetchAllUsers() -> AnyPublisher<[User], Error> {
        if let result = fetchAllUsersResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchAllRepositories() -> AnyPublisher<[Repository], Error> {
        if let result = fetchAllRepositoriesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchUserRepositories(user: User) -> AnyPublisher<[Repository], Error> {
        if let result = fetchUserRepositoriesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher()
    }
}
