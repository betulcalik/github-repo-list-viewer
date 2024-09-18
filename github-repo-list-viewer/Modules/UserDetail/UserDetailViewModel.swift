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
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    
    private var currentPage: Int = 1
    private var maxReposPerPage: Int = 30
    
    // MARK: Init
    init(user: User, githubManager: GithubManagerProtocol, githubDataModelManager: GithubDataModelManagerProtocol) {
        self.user = user
        self.githubManager = githubManager
        self.githubDataModelManager = githubDataModelManager
        
        fetchUserRepositories()
    }
    
    // MARK: Public Methods
    func fetchUserRepositories() {
        guard !isLoading else { return }
        isLoading = true
        
        guard let username = user.username else {
            isLoading = false
            return
        }
        
        let model = GetUserRepositoryRequestModel(username: username, maxReposPerPage: maxReposPerPage, page: currentPage)
        
        githubManager.getUserRepositories(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                githubDataModelManager.saveRepositories(user: self.user, models: response)
                
                DispatchQueue.main.async {
                    self.fetchUserRepositoriesFromCoreData()
                }
                
                currentPage += 1
            })
            .store(in: &cancellables)
    }
    
    func fetchMoreRepositories() {
        fetchUserRepositories()
    }
    
    func fetchUserRepositoriesFromCoreData() {
        githubDataModelManager.fetchUserRepositories(user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error fetching from Core Data: \(error)")
                }
            }, receiveValue: { [weak self] repositories in
                guard let self = self else { return }
                self.repositories = repositories
            })
            .store(in: &cancellables)
    }
    
    func resetPagination() {
        currentPage = 1
    }
    
    func sortRepositoriesByCreatedAt() {
        repositories.sort {
            guard let date1 = $0.createdAt, let date2 = $1.createdAt else {
                return false
            }
            return date1 < date2
        }
    }
    
    func sortRepositoriesByUpdatedAt() {
        repositories.sort {
            guard let date1 = $0.updatedAt, let date2 = $1.updatedAt else {
                return false
            }
            return date1 < date2
        }
    }
    
    func sortRepositoriesByStarCount() {
        repositories.sort { $0.starCount > $1.starCount }
    }
}
