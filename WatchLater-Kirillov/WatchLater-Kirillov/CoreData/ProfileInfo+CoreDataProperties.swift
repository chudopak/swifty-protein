//
//  ProfileInfo+CoreDataProperties.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation
import CoreData

extension ProfileInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileInfo> {
        return NSFetchRequest<ProfileInfo>(entityName: "ProfileInfo")
    }

    @NSManaged public var name: String
    @NSManaged public var aboutMe: String
    @NSManaged public var genres: [String]
    @NSManaged public var photoId: String
    @NSManaged public var id: Int64
}
