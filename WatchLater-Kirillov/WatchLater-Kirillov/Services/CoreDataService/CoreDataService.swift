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
}
