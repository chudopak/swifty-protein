//
//  FilmInfo+CoreDataProperties.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/28/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation
import CoreData

extension FilmInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilmInfo> {
        return NSFetchRequest<FilmInfo>(entityName: "FilmInfo")
    }

    @NSManaged public var id: String
    @NSManaged public var posterID: String?
    @NSManaged public var rating: String
    @NSManaged public var title: String
    @NSManaged public var titleDescription: String?
    @NSManaged public var year: String
    @NSManaged public var genres: [String]?
}
