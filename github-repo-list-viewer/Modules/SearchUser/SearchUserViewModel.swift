//
//  SearchUserViewModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

final class SearchUserViewModel: ObservableObject {
    
    // MARK: Properties
    private let githubManager: GithubManagerProtocol
    private let githubDataModelManager: GithubDataModelManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var searchedUser: User?
    @Published var getUserError: NetworkError?
    
    @Published var shouldNavigateToDetail: Bool = false
    
    // MARK: Init
    init(githubManager: GithubManagerProtocol, githubDataModelManager: GithubDataModelManagerProtocol) {
        self.githubManager = githubManager
        self.githubDataModelManager = githubDataModelManager
    }
    
    // MARK: Public Methods
    func getUser(username: String) {
        let model = GetUserRequestModel(username: username)
        isLoading = true
        
        githubManager.getUser(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error: \(error)")
                    showAlert = true
                    getUserError = error
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                saveUser(model: response)
            })
            .store(in: &cancellables)
    }
    
    // MARK: Private Methods
    private func saveUser(model: GetUserResponseModel) {
        githubDataModelManager.saveUser(model: model)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error saving user: \(error)")
                }
            }, receiveValue: { [weak self] user in
                self?.searchedUser = user
                self?.shouldNavigateToDetail = true
            })
            .store(in: &cancellables)
        }
}
