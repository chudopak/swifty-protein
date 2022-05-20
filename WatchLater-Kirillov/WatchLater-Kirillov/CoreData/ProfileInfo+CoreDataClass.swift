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
        let fetchData = FetchRequestData(predicate: nil,
                                         sortDescriptors: nil,
                                         fetchLimit: 0,
                                         fetchOffset: 0)
        CoreDataService.shared.get(
            type: ProfileInfo.self,
            fetchRequestData: fetchData,
            completion: completion
        )
    }
}
