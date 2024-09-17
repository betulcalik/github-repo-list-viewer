//
//  UserDetailViewModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import Foundation
import Combine

final class UserDetailViewModel: ObservableObject {
    
    // MARK: Properties
    private let githubManager: GithubManagerProtocol
    private let githubDataModelManager: GithubDataModelManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var user: User
    @Published var isLoading: Bool = false
    
    // MARK: Init
    init(user: User, githubManager: GithubManagerProtocol, githubDataModelManager: GithubDataModelManagerProtocol) {
        self.user = user
        self.githubManager = githubManager
        self.githubDataModelManager = githubDataModelManager
    }
    
    // MARK: Public Methods
    func fetchUserRepositories() {
        guard let username = user.username else { return }
        let model = GetUserRepositoryRequestModel(username: username)
        isLoading = true
        
        githubManager.getUserRepositories(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                debugPrint("Response: \(response)")
            })
            .store(in: &cancellables)
    }
}
