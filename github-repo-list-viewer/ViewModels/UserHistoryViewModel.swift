//
//  UserHistoryViewModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import CoreData
import Combine

final class UserHistoryViewModel: ObservableObject {
    
    // MARK: - Properties
    private let githubDataModelManager: GithubDataModelManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var users: [User] = []
    
    // MARK: - Init
    init(githubDataModelManager: GithubDataModelManagerProtocol) {
        self.githubDataModelManager = githubDataModelManager
        fetchUsers()
    }
    
    // MARK: - Fetch Users
    func fetchUsers() {
        githubDataModelManager.fetchAllUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    debugPrint("Failed to fetch users: \(error)")
                }
            }, receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.users = users
            })
            .store(in: &cancellables)
    }
}
