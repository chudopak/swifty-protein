//
//  ProfileInfo+CoreDataClass.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation
import CoreData

public class ProfileInfo: NSManagedObject {
    static func fetchUserInfo(completion: @escaping (Result<[ProfileInfo], Error>) -> Void) {
        let fetchData = FetchRequestData(predicate: nil)
        CoreDataService.shared.get(
            type: ProfileInfo.self,
            fetchRequestData: fetchData,
            completion: completion
        )
    }
    
    static func changeProfileInfo(info: ProfileInfo,
                                  completion: @escaping (ProfileInfo) -> Void) {
        CoreDataService.shared.managedObjectContext.performAndWait {
            completion(info)
        }
    }
    
    static func saveProfileInfoChanges() {
        CoreDataService.shared.saveContext()
    }
    
    static func addNewProfileInfo(completion: @escaping (ProfileInfo) -> Void) {
        CoreDataService.shared.save(with: ProfileInfo.self, predicate: nil) { object, context in
            context.performAndWait {
                completion(object)
            }
        }
    }
}
