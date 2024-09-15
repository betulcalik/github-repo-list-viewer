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
}

final class GithubManager: GithubManagerProtocol {
    
    // MARK: Properties
    private let networkManager: NetworkManagerProtocol
    
    // MARK: Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    func getUser(model: GetUserRequestModel) -> AnyPublisher<GetUserResponseModel, NetworkError> {
        networkManager.fetch(from: "/users/" + model.username)
    }
    
}
