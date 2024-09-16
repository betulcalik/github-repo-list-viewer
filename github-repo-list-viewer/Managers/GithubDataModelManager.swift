//
//  GithubDataModelManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

protocol GithubDataModelManagerProtocol {
    func saveUser(responseModel: GetUserResponseModel)
}

final class GithubDataModelManager: GithubDataModelManagerProtocol {
    
    // MARK: Properties
    let coreDataManager: CoreDataManagerProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Init
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: Public Methods
    func saveUser(responseModel: GetUserResponseModel) {
        let predicate = NSPredicate(format: "username == %@", responseModel.username)
        
        coreDataManager.fetch(entity: User.self, predicate: predicate, sortDescriptors: nil)
            .flatMap { [weak self] existingUsers -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if existingUsers.isEmpty {
                    return saveNewUser(responseModel: responseModel)
                }
                
                debugPrint("User with username \(responseModel.username) already exists.")
                return Just(true)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error during saveUser operation: \(error.localizedDescription)")
                }
            }, receiveValue: { success in
                if success {
                    debugPrint("User successfully saved: \(responseModel)")
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: Private Methods
    private func saveNewUser(responseModel: GetUserResponseModel) -> AnyPublisher<Bool, Error> {
        coreDataManager.add(entity: User.self) { newUser in
            newUser.username = responseModel.username
            newUser.name = responseModel.name
            newUser.company = responseModel.company
            newUser.location = responseModel.location
            newUser.bio = responseModel.bio
            newUser.publicRepoCount = Int32(responseModel.publicRepoCount ?? 0)
            newUser.followerCount = Int32(responseModel.followerCount ?? 0)
            newUser.followingCount = Int32(responseModel.followingCount ?? 0)
        }
    }
}
