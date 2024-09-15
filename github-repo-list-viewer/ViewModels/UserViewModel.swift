//
//  UserViewModel.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

final class UserViewModel: ObservableObject {
    
    // MARK: Properties
    private let githubManager: GithubManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    
    @Published var getUserError: NetworkError?
    
    // MARK: Init
    init(githubManager: GithubManagerProtocol) {
        self.githubManager = githubManager
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
                debugPrint("Response: \(response)")
            })
            .store(in: &cancellables)
    }
}
