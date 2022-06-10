//
//  Element+CoreDataProperties.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//
//

import UIKit
import CoreData

extension Element {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Element> {
        return NSFetchRequest<Element>(entityName: "Element")
    }

    @NSManaged public var index: Int64
    @NSManaged public var name: String
    @NSManaged public var color: UIColor
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var z: Double
    @NSManaged public var conections: [Int]
}

extension Element: Identifiable {
}
