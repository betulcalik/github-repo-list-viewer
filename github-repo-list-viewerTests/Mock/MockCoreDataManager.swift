//
//  MockCoreDataManager.swift
//  github-repo-list-viewerTests
//
//  Created by Betül Çalık on 19.09.2024.
//

import Foundation
import CoreData
import Combine
@testable import github_repo_list_viewer

class MockCoreDataManager: CoreDataManagerProtocol {
    var fetchResult: [NSManagedObject] = []
    var addResult: Bool = true
    var updateResult: Bool = true
    var deleteResult: Bool = true
    var fetchError: Error?
    var addError: Error?
    var updateError: Error?
    var deleteError: Error?

    func fetch<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error> {
        if let error = fetchError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        let result = fetchResult.compactMap { $0 as? T }
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func add<T: NSManagedObject>(entity: T.Type, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error> {
        if let error = addError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return Just(addResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func update<T: NSManagedObject>(object: T, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error> {
        if let error = updateError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return Just(updateResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func delete<T: NSManagedObject>(object: T) -> AnyPublisher<Bool, Error> {
        if let error = deleteError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return Just(deleteResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
