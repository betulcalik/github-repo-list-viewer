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
    @StateObject private var userHistoryViewModel: SearchHistoryViewModel
    
    @StateObject private var githubManager: GithubManager
    @StateObject private var githubDataModelManager: GithubDataModelManager
    
    init() {
        let githubNetworkManager = NetworkManager(urlSession: URLSession.shared,
                                                  baseURL: URL(string: "https://api.github.com")!,
                                                  apiKey: APIKeyManager.shared.getGithubAPIKey())
        let githubManagerInstance = GithubManager(networkManager: githubNetworkManager)
        
        let githubDataModelContainer = NSPersistentContainer(name: Storages.github.rawValue)
        let githubCoreDataManager = CoreDataManager(container: githubDataModelContainer)
        let githubDataModelManagerInstance = GithubDataModelManager(coreDataManager: githubCoreDataManager)
        
        _githubManager = StateObject(wrappedValue: githubManagerInstance)
        _githubDataModelManager = StateObject(wrappedValue: githubDataModelManagerInstance)
        
        _searchUserViewModel = StateObject(wrappedValue: SearchUserViewModel(githubManager: githubManagerInstance,
                                                                       githubDataModelManager: githubDataModelManagerInstance))
        _userHistoryViewModel = StateObject(wrappedValue: SearchHistoryViewModel(githubDataModelManager: githubDataModelManagerInstance))
    }
    
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(searchUserViewModel)
                .environmentObject(userHistoryViewModel)
                .environmentObject(githubManager)
                .environmentObject(githubDataModelManager)
        }
    }
}

