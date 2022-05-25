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
        let sort = NSSortDescriptor(key: #keyPath(FilmInfo.id), ascending: true)
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
    
    static func changeObjectInCoreData(id: Int,
                                       completion: @escaping (Result<FilmInfo, Error>) -> Void) {
        let predicate = NSPredicate(
            format: "%K = \(id)",
            #keyPath(FilmInfo.id)
        )
        let fetchData = FetchRequestData(
            predicate: predicate,
            fetchLimit: 1
        )
        CoreDataService.shared.get(
                type: FilmInfo.self,
                fetchRequestData: fetchData
        ) { result in
            switch result {
            case .success(let object):
                if let obj = object.first {
                    completion(.success(obj))
                    CoreDataService.shared.saveContext()
                } else {
                    completion(.failure(BaseError.noData))
                }
            
            case .failure:
                completion(.failure(BaseError.noData))
            }
        }
    }
    
    static func saveChanges() {
        CoreDataService.shared.saveContext()
    }
    
    static func deleteFilms(films: [FilmInfo],
                            completion: @escaping () -> Void) {
        CoreDataService.shared.deleteObjects(objects: films) {
            completion()
        }
    }
    
    static func saveObjects(
        predicate: NSPredicate?,
        amount: Int,
        saveCompletion: @escaping ([FilmInfo]) -> Void
    ) {
        CoreDataService.shared.save(
            with: FilmInfo.self,
            predicate: nil,
            amount: amount
        ) { objects, managedObjectContext in
            managedObjectContext.performAndWait {
                saveCompletion(objects)
            }
        }
    }
    
    static func interactWithFilm(film: FilmInfo,
                                 completion: @escaping (FilmInfo) -> Void) {
        CoreDataService.shared.managedObjectContext.performAndWait {
            completion(film)
        }
    static func fetchMoviesWith(
        title: String,
        fetchLimit: Int,
        completion: @escaping (Result<[FilmInfo], Error>) -> Void
    ) {
        let predicate = NSPredicate(
            format: "%K CONTAINS[c] '\(title)'",
            #keyPath(FilmInfo.title)
        )
        let sort = NSSortDescriptor(key: "id", ascending: true)
        let fetchData = FetchRequestData(predicate: predicate,
                                         sortDescriptors: [sort],
                                         fetchLimit: fetchLimit,
                                         fetchOffset: 0)
        CoreDataService.shared.get(
            type: FilmInfo.self,
            fetchRequestData: fetchData,
            completion: completion
        )
    }
}
