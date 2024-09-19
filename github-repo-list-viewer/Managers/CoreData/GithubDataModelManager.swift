//
//  GithubDataModelManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import Combine

protocol GithubDataModelManagerProtocol {
    func saveUser(model: GetUserResponseModel) -> AnyPublisher<User, Error>
    func saveRepository(user: User, model: GetUserRepositoryResponseModel)
    func saveRepositories(user: User, models: [GetUserRepositoryResponseModel])
    
    func fetchAllUsers() -> AnyPublisher<[User], Error>
    func fetchAllRepositories() -> AnyPublisher<[Repository], Error>
    func fetchUserRepositories(user: User) -> AnyPublisher<[Repository], Error>
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
    func saveUser(model: GetUserResponseModel) -> AnyPublisher<User, Error> {
        let predicate = NSPredicate(format: "username == %@", model.username)
        
        return coreDataManager.fetch(entity: User.self, predicate: predicate, sortDescriptors: nil)
            .flatMap { [weak self] existingUsers -> AnyPublisher<User, Error> in
                guard let self = self else { return Fail(error: NSError(domain: "", code: 0, userInfo: nil)).eraseToAnyPublisher() }
                
                if let existingUser = existingUsers.first {
                    return Just(existingUser)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.saveNewUser(model: model)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAllUsers() -> AnyPublisher<[User], Error> {
        return coreDataManager.fetch(entity: User.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: true)])
            .eraseToAnyPublisher()
    }
    
    func saveRepositories(user: User, models: [GetUserRepositoryResponseModel]) {
        for model in models {
            saveRepository(user: user, model: model)
        }
    }
    
    func saveRepository(user: User, model: GetUserRepositoryResponseModel) {
        let predicate = NSPredicate(format: "id == %d", model.id)
        
        coreDataManager.fetch(entity: Repository.self, predicate: predicate, sortDescriptors: nil)
            .flatMap { [weak self] existingRepositories -> AnyPublisher<Bool, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                if existingRepositories.isEmpty {
                    return saveNewRepository(user: user, model: model)
                }
                
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
    
    func fetchAllRepositories() -> AnyPublisher<[Repository], Error> {
        return coreDataManager.fetch(entity: Repository.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
            .eraseToAnyPublisher()
    }
    
    func fetchUserRepositories(user: User) -> AnyPublisher<[Repository], Error> {
        let predicate = NSPredicate(format: "user == %@", user)
        
        return coreDataManager.fetch(entity: Repository.self, predicate: predicate, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
            .eraseToAnyPublisher()
    }
    
    // MARK: Private Methods
    private func saveNewUser(model: GetUserResponseModel) -> AnyPublisher<User, Error> {
        return coreDataManager.add(entity: User.self) { newUser in
            newUser.username = model.username
            newUser.name = model.name
            newUser.company = model.company
            newUser.location = model.location
            newUser.bio = model.bio
            newUser.publicRepoCount = Int32(model.publicRepoCount ?? 0)
            newUser.followerCount = Int32(model.followerCount ?? 0)
            newUser.followingCount = Int32(model.followingCount ?? 0)
            newUser.createdAt = Date()
        }
        .flatMap { _ in
            // Fetch the newly created user
            let predicate = NSPredicate(format: "username == %@", model.username)
            return self.coreDataManager.fetch(entity: User.self, predicate: predicate, sortDescriptors: nil)
                .compactMap { $0.first }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    private func saveNewRepository(user: User, model: GetUserRepositoryResponseModel) -> AnyPublisher<Bool, Error> {
        coreDataManager.add(entity: Repository.self) { newRepository in
            newRepository.id = Int64(model.id)
            newRepository.name = model.name
            newRepository.isPrivate = model.isPrivate ?? false
            newRepository.desc = model.description
            newRepository.starCount = Int16(model.starCount ?? 0)
            newRepository.language = model.language
            newRepository.topics = model.topics
            newRepository.watchers = Int16(model.watchers ?? 0)
            
            if let createdAt = model.createdAt {
                newRepository.createdAt = DateFormatter.iso8601.date(from: createdAt)
            }
            
            if let updatedAt = model.updatedAt {
                newRepository.updatedAt = DateFormatter.iso8601.date(from: updatedAt)
            }
            
            newRepository.user = user
        }
    }
}
