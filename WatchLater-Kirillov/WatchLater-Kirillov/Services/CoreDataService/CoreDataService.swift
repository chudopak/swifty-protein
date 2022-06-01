//
//  CoreDataService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/16/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataService {
    
    static let name = "FilmsDataModel"
    
    static let shared = CoreDataService()
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataService.name)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private(set) lazy var managedObjectContext = persistentContainer.newBackgroundContext()
    
    func saveContext() {
        DispatchQueue.main.async { [weak self] in
            self?.managedObjectContext.performAndWait {
                if let hasChanged = self?.managedObjectContext.hasChanges,
                   hasChanged {
                    do {
                        try  self?.managedObjectContext.save()
                    } catch {
                        let nserror = error as NSError
                        assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
    }
    
    func get<T>(
        type: T.Type,
        fetchRequestData: FetchRequestData,
        completion: @escaping (Result<[T], Error>) -> Void
    ) where T: NSManagedObject {
        let request = buildFetchRequest(type: T.self, requestData: fetchRequestData)
        DispatchQueue.main.async { [weak self] in
            self?.managedObjectContext.perform {
                do {
                    if let filmsInfo = try self?.managedObjectContext.fetch(request) {
                        completion(.success(filmsInfo))
                    } else {
                        completion(.failure(BaseError.noData))
                    }
                } catch {
                    let nserror = error as NSError
                    print("Unresolved error \(nserror), \(nserror.userInfo)")
                    completion(.failure(nserror))
                }
            }
        }
    }
    
    func getSync<T>(
        type: T.Type,
        fetchRequestData: FetchRequestData
    ) -> [T]? where T: NSManagedObject {
        let request = buildFetchRequest(type: T.self, requestData: fetchRequestData)
        var filmsInfo: [T]?
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async { [weak self, group] in
            self?.persistentContainer.performBackgroundTask { [group] context in
                do {
                    filmsInfo = try context.fetch(request)
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                group.leave()
            }
        }
        group.wait()
        return filmsInfo
    }
    
    func deleteAll<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        completion: @escaping (Bool) -> Void
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        DispatchQueue.main.async { [weak self] in
            self?.persistentContainer.performBackgroundTask { context in
                do {
                    try context.execute(deleteRequest)
                    try context.save()
                    completion(true)
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                    completion(false)
                }
            }
        }
    }
    
    func deleteObjects(objects: [NSManagedObject],
                       completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.managedObjectContext.perform {
                for object in objects {
                    self?.managedObjectContext.delete(object)
                }
                completion()
            }
        }
    }
    
    func save<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        saveBlock: @escaping (T, NSManagedObjectContext) -> Void
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let context = managedObjectContext
        DispatchQueue.main.async {
            context.performAndWait {
                let object = T(context: context)
                saveBlock(object, context)
            }
        }
    }
    
    func save<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        amount: Int,
        saveBlock: @escaping ([T], NSManagedObjectContext) -> Void
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let context = managedObjectContext
        DispatchQueue.main.async {
            context.perform {
                var objects = [T]()
                objects.reserveCapacity(amount)
                for _ in 0..<amount {
                    objects.append(T(context: context))
                }
                saveBlock(objects, context)
            }
        }
    }
    
    private func buildFetchRequest<T>(
        type: T.Type,
        requestData: FetchRequestData
    ) -> NSFetchRequest<T> where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = requestData.predicate
        if requestData.fetchLimit != .zero {
            request.fetchLimit = requestData.fetchLimit
        }
        if requestData.fetchOffset != .zero {
            request.fetchOffset = requestData.fetchOffset
        }
        request.sortDescriptors = requestData.sortDescriptors
        return request
    }
}
