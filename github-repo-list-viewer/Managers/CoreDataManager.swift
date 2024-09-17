//
//  CoreDataManager.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import Foundation
import CoreData
import Combine

protocol CoreDataManagerProtocol {
    func fetch<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> AnyPublisher<[T], Error>
    func add<T: NSManagedObject>(entity: T.Type, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error>
    func update<T: NSManagedObject>(object: T, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error>
    func delete<T: NSManagedObject>(object: T) -> AnyPublisher<Bool, Error>
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: Properties
    let container: NSPersistentContainer
    
    // MARK: Init
    init(container: NSPersistentContainer) {
        self.container = container
        loadContainer()
    }
    
    // MARK: Private Methods
    func loadContainer() {
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                debugPrint("Error loading core data: \(error.localizedDescription)")
                return
            }
            
            debugPrint("Successfully loaded core data.")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: Public Methods
    func fetch<T: NSManagedObject>(entity: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> AnyPublisher<[T], Error> {
        return Future<[T], Error> { promise in
            let mainContext = self.container.viewContext
            
            mainContext.perform {
                let request = T.fetchRequest()
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                request.returnsObjectsAsFaults = false
                
                do {
                    let results = try mainContext.fetch(request) as? [T] ?? []
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func add<T: NSManagedObject>(entity: T.Type, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error> {
        let backgroundContext = createBackgroundContext()
        
        return Future<Bool, Error> { promise in
            backgroundContext.perform {
                let entityName = String(describing: entity)
                guard let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: backgroundContext) as? T else {
                    promise(.success(false))
                    return
                }
                configure(newObject)
                
                do {
                    try backgroundContext.save()
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update<T: NSManagedObject>(object: T, configure: @escaping (T) -> Void) -> AnyPublisher<Bool, Error> {
        let backgroundContext = createBackgroundContext()
        
        return Future<Bool, Error> { promise in
            backgroundContext.perform {
                let objectInContext = backgroundContext.object(with: object.objectID) as? T
                guard let managedObject = objectInContext else {
                    promise(.success(false))
                    return
                }
                
                configure(managedObject)
                
                do {
                    try backgroundContext.save()
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete<T: NSManagedObject>(object: T) -> AnyPublisher<Bool, Error> {
        let backgroundContext = createBackgroundContext()
        
        return Future<Bool, Error> { promise in
            backgroundContext.perform {
                let objectInContext = backgroundContext.object(with: object.objectID) as? T
                guard let managedObject = objectInContext else {
                    promise(.success(false))
                    return
                }
                
                backgroundContext.delete(managedObject)
                
                do {
                    try backgroundContext.save()
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: Private Methods
    private func createBackgroundContext() -> NSManagedObjectContext {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        return backgroundContext
    }
}
