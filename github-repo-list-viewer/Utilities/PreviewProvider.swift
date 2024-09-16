//
//  PreviewProvider.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import CoreData

final class PreviewProvider {
    
    static let shared = PreviewProvider()
    
    let userViewModel = SearchUserViewModel(
        githubManager:
            GithubManager(
                networkManager:
                    NetworkManager(urlSession: URLSession.shared,
                                   baseURL: URL(string: "https://api.github.com")!,
                                   apiKey: APIKeyManager.shared.getGithubAPIKey())),
        githubDataModelManager:
            GithubDataModelManager(
                coreDataManager:
                    CoreDataManager(
                        container:
                            NSPersistentContainer(name: "GithubDataModel")
                    )
            )
    )
    
    let userHistoryViewModel = UserHistoryViewModel(
        githubDataModelManager:
            GithubDataModelManager(
                coreDataManager:
                    CoreDataManager(
                        container:
                            NSPersistentContainer(name: "GithubDataModel")
                    )
            )
    )
    
    private init() { }
}
