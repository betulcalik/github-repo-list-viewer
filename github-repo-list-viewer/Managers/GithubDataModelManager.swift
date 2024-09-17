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
    func saveRepository(model: GetUserRepositoryResponseModel)
    
    func fetchAllUsers() -> AnyPublisher<[User], Error>
}

final class GithubDataModelManager: GithubDataModelManagerProtocol, ObservableObject {
    
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
                    debugPrint("Error during fetch user operation: \(error.localizedDescription)")
                }
            }, receiveValue: { success in })
            .store(in: &cancellables)
    }
    
    func saveRepository(model: GetUserRepositoryResponseModel) {
        let predicate = NSPredicate(format: "id == %d", model.id)
        
        coreDataManager.fetch(entity: Repository.self, predicate: predicate, sortDescriptors: nil)
            .flatMap { [weak self] existingRepositories -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if existingRepositories.isEmpty {
                    return saveNewRepository(model: model)
                }
                
                debugPrint("User with repository \(model.name) already exists.")
                return Just(true)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("Error during fetch repository operation: \(error.localizedDescription)")
                }
            }, receiveValue: { success in })
            .store(in: &cancellables)
    }
    
    func fetchAllUsers() -> AnyPublisher<[User], Error> {
        return coreDataManager.fetch(entity: User.self, predicate: nil, sortDescriptors: nil)
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
    
    private func saveNewRepository(model: GetUserRepositoryResponseModel) -> AnyPublisher<Bool, Error> {
        coreDataManager.add(entity: Repository.self) { newRepository in
            newRepository.id = Int64(model.id)
            newRepository.name = model.name
            newRepository.isPrivate = model.isPrivate ?? false
            newRepository.desc = model.description
           // newRepository.createdAt
           // newRepository.updatedAt
            newRepository.starCount = Int16(model.starCount ?? 0)
            newRepository.language = model.language
            newRepository.topics = model.topics
            newRepository.watchers = Int16(model.watchers ?? 0)
        }
    }
}
