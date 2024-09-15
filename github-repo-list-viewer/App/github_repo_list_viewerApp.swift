//
//  github_repo_list_viewerApp.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 13.09.2024.
//

import SwiftUI

@main
struct github_repo_list_viewerApp: App {
    
    @StateObject private var userViewModel: UserViewModel
    
    init() {
        let networkManager = NetworkManager(urlSession: URLSession.shared,
                                            baseURL: URL(string: "https://api.github.com")!,
                                            apiKey: APIKeyManager.shared.getGithubAPIKey())
        let githubManager = GithubManager(networkManager: networkManager)
        _userViewModel = StateObject(wrappedValue: UserViewModel(githubManager: githubManager))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SearchUserView()
                    .environmentObject(userViewModel)
            }
        }
    }
}
