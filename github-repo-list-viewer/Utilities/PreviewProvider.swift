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
    
    // Expose githubManager for preview
    let searchUserViewModel: SearchUserViewModel
    let userHistoryViewModel: SearchHistoryViewModel
    let githubManager: GithubManager
    
    private init() {
        let networkManager = NetworkManager(
            urlSession: URLSession.shared,
            baseURL: URL(string: "https://api.github.com")!,
            apiKey: APIKeyManager.shared.getGithubAPIKey()
        )
        
        githubManager = GithubManager(networkManager: networkManager)
        
        let persistentContainer = NSPersistentContainer(name: "GithubDataModel")
        let coreDataManager = CoreDataManager(container: persistentContainer)
        let githubDataModelManager = GithubDataModelManager(coreDataManager: coreDataManager)
        
        searchUserViewModel = SearchUserViewModel(
            githubManager: githubManager,
            githubDataModelManager: githubDataModelManager
        )
        
        userHistoryViewModel = SearchHistoryViewModel(
            githubDataModelManager: githubDataModelManager
        )
    }
}

