//
//  GithubManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

protocol GithubManagerProtocol {
    func getUser(model: GetUserRequestModel) -> AnyPublisher<GetUserResponseModel, NetworkError>
    func getUserRepositories(model: GetUserRepositoryRequestModel) -> AnyPublisher<[GetUserRepositoryResponseModel], NetworkError>
}

final class GithubManager: GithubManagerProtocol, ObservableObject {
    
    // MARK: Properties
    private let networkManager: NetworkManagerProtocol
    
    enum Path: String {
        case users = "users"
        case repos = "repos"
    }
    
    // MARK: Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    func getUser(model: GetUserRequestModel) -> AnyPublisher<GetUserResponseModel, NetworkError> {
        networkManager.fetch(from: "/" + Path.users.rawValue + "/" + model.username, queryParameters: nil)
    }
    
    func getUserRepositories(model: GetUserRepositoryRequestModel) -> AnyPublisher<[GetUserRepositoryResponseModel], NetworkError> {
        networkManager.fetch(from: "/" + Path.users.rawValue + "/" + model.username + "/" + Path.repos.rawValue, 
                             queryParameters: ["per_page": "\(model.maxReposPerPage)",
                                               "page": "\(model.page)"])
    }
}
