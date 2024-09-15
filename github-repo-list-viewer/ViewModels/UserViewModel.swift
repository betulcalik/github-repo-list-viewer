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
    
    // MARK: Init
    init(githubManager: GithubManagerProtocol) {
        self.githubManager = githubManager
    }
    
    // MARK: Public Methods
    func getUser(username: String) {
        let model = GetUserRequestModel(username: username)
        
        githubManager.getUser(model: model)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // Handle successful completion
                    break
                case .failure(let error):
                    // Handle error
                    debugPrint("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                debugPrint("Response: \(response)")
            })
            .store(in: &cancellables)
    }
}
