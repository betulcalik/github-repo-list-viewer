//
//  github_repo_list_viewerApp.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 13.09.2024.
//

import SwiftUI
import CoreData

@main
struct github_repo_list_viewerApp: App {
    
    @StateObject private var searchUserViewModel: SearchUserViewModel
    @StateObject private var userHistoryViewModel: UserHistoryViewModel
    
    init() {
        let githubNetworkManager = NetworkManager(urlSession: URLSession.shared,
                                                  baseURL: URL(string: "https://api.github.com")!,
                                                  apiKey: APIKeyManager.shared.getGithubAPIKey())
        let githubManager = GithubManager(networkManager: githubNetworkManager)
        
        let githubDataModelContainer = NSPersistentContainer(name: Storages.github.rawValue)
        let githubCoreDataManager = CoreDataManager(container: githubDataModelContainer)
        let githubDataModelManager = GithubDataModelManager(coreDataManager: githubCoreDataManager)
        
        _searchUserViewModel = StateObject(wrappedValue: SearchUserViewModel(githubManager: githubManager,
                                                                       githubDataModelManager: githubDataModelManager))
        _userHistoryViewModel = StateObject(wrappedValue: UserHistoryViewModel(githubDataModelManager: githubDataModelManager))
    }
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(searchUserViewModel)
                .environmentObject(userHistoryViewModel)
        }
    }
}
