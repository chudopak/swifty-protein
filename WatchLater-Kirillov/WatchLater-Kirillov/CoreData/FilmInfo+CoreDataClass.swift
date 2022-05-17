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
    static func fetchPageFromCoreData(page: Int, size: Int, watched: Bool) -> [FilmInfo] {
        let predicate = NSPredicate(
            format: "%K = \(watched)",
            #keyPath(FilmInfo.isWatched)
        )
        let sort = NSSortDescriptor(key: "id", ascending: true)
        let fetchData = GetModel(predicate: predicate,
                                 sortDescriptors: [sort],
                                 fetchLimit: size,
                                 fetchOffset: page * size)
        if let films = CoreDataService.shared.get(type: FilmInfo.self,
                                                  fetchRequestData: fetchData) {
            return films
        }
        return [FilmInfo]()
    }
}
