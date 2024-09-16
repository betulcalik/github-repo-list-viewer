//
//  GithubDataModelManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

protocol GithubDataModelManagerProtocol {
    func saveUser(model: GetUserResponseModel)
    func fetchAllUsers() -> AnyPublisher<[User], Error>
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
    func saveUser(model: GetUserResponseModel) {
        let predicate = NSPredicate(format: "username == %@", model.username)
        
        coreDataManager.fetch(entity: User.self, predicate: predicate, sortDescriptors: nil)
            .flatMap { [weak self] existingUsers -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if existingUsers.isEmpty {
                    return saveNewUser(model: model)
                }
                
                debugPrint("User with username \(model.username) already exists.")
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
                    debugPrint("User successfully saved: \(model)")
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: Private Methods
    private func saveNewUser(model: GetUserResponseModel) -> AnyPublisher<Bool, Error> {
        coreDataManager.add(entity: User.self) { newUser in
            newUser.username = model.username
            newUser.name = model.name
            newUser.company = model.company
            newUser.location = model.location
            newUser.bio = model.bio
            newUser.publicRepoCount = Int32(model.publicRepoCount ?? 0)
            newUser.followerCount = Int32(model.followerCount ?? 0)
            newUser.followingCount = Int32(model.followingCount ?? 0)
        }
    }
    
    func fetchAllUsers() -> AnyPublisher<[User], Error> {
        return coreDataManager.fetch(entity: User.self, predicate: nil, sortDescriptors: nil)
    }
}
