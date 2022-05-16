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
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func get<T>(type: T.Type,
                fetchRequestData: GetModel) -> [T]? where T: NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = fetchRequestData.predicate
        if fetchRequestData.fetchLimit != .zero {
            request.fetchLimit = fetchRequestData.fetchLimit
        }
        if fetchRequestData.fetchOffset != .zero {
            request.fetchOffset = fetchRequestData.fetchOffset
        }
        request.sortDescriptors = fetchRequestData.sortDescriptors
        do {
            return try managedObjectContext.fetch(request)
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
    
    func delete<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        completion: @escaping (Bool) -> Void
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        persistentContainer.performBackgroundTask { context in
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
    
    func deleteObjects(objects: [NSManagedObject],
                       completion: @escaping () -> Void) {
        persistentContainer.performBackgroundTask { context in
            for object in objects {
                context.delete(object)
            }
            completion()
        }
    }
    
    public func save<T>(
        with _: T.Type,
        predicate: NSPredicate?,
        saveBlock: @escaping (T, NSManagedObjectContext) -> Void
    ) where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        managedObjectContext.performAndWait {
            let object = T(context: managedObjectContext)
            saveBlock(object, managedObjectContext)
        }
    }
}
