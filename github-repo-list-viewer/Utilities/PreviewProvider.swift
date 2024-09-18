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
    
    let networkMonitor: NetworkMonitor
    
    let searchUserViewModel: SearchUserViewModel
    let searchHistoryViewModel: SearchHistoryViewModel
    let userDetailViewModel: UserDetailViewModel
    
    let githubManager: GithubManager
    let githubDataModelManager: GithubDataModelManager
    
    let mockUser: User
    
    let repositoryGridItems: [RepositoryGridItemModel] = [
        .init(name: "Repository Name",
              isPrivate: false,
              description: "Repository Description",
              createdAt: Date(),
              updatedAt: Date(),
              starCount: 10,
              language: "Python",
              topics: ["Python", "OpenCV"],
              watchers: 10)
    ]
    
    private init() {
        networkMonitor = NetworkMonitor()
        
        let networkManager = NetworkManager(
            urlSession: URLSession.shared,
            baseURL: URL(string: "https://api.github.com")!,
            apiKey: APIKeyManager.shared.getGithubAPIKey()
        )
        
        githubManager = GithubManager(networkManager: networkManager)
        
        let persistentContainer = NSPersistentContainer(name: "GithubDataModel")
        let coreDataManager = CoreDataManager(container: persistentContainer)
        githubDataModelManager = GithubDataModelManager(coreDataManager: coreDataManager)
        
        let mockContext = persistentContainer.viewContext
        mockUser = User.mockUser(context: mockContext)
        
        searchUserViewModel = SearchUserViewModel(
            githubManager: githubManager,
            githubDataModelManager: githubDataModelManager
        )
        
        searchHistoryViewModel = SearchHistoryViewModel(
            githubDataModelManager: githubDataModelManager
        )
        
        userDetailViewModel = UserDetailViewModel(user: mockUser,
                                                  githubManager: githubManager,
                                                  githubDataModelManager: githubDataModelManager)
    }
}


extension User {
    
    static func mockUser(context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.username = "MockUsername"
        user.bio = "This is a mock bio for testing."
        user.location = "Mock City"
        user.company = "Mock Company"
        return user
    }
    
}
