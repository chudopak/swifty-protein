//
//  FilmInfo+CoreDataClass.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/28/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation
import CoreData

@objc(FilmInfo)
public class FilmInfo: NSManagedObject {
    static func fetchPageFromCoreData(
        page: Int,
        size: Int,
        watched: Bool,
        completion: @escaping (Result<[FilmInfo], Error>) -> Void
    ) {
        let predicate = NSPredicate(
            format: "%K = \(watched)",
            #keyPath(FilmInfo.isWatched)
        )
        let sort = NSSortDescriptor(key: "id", ascending: true)
        let fetchData = FetchRequestData(predicate: predicate,
                                         sortDescriptors: [sort],
                                         fetchLimit: size,
                                         fetchOffset: page * size)
        CoreDataService.shared.get(
            type: FilmInfo.self,
            fetchRequestData: fetchData,
            completion: completion
        )
    }
}
