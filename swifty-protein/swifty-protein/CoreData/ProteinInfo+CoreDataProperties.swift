//
//  ProteinInfo+CoreDataProperties.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//
//

import Foundation
import CoreData

extension ProteinInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProteinInfo> {
        return NSFetchRequest<ProteinInfo>(entityName: "ProteinInfo")
    }

    @NSManaged public var name: String
    @NSManaged public var elements: NSSet?
}

// MARK: Generated accessors for elements
extension ProteinInfo {

    @objc(addElementsObject:)
    @NSManaged public func addToElements(_ value: Element)

    @objc(removeElementsObject:)
    @NSManaged public func removeFromElements(_ value: Element)

    @objc(addElements:)
    @NSManaged public func addToElements(_ values: NSSet)

    @objc(removeElements:)
    @NSManaged public func removeFromElements(_ values: NSSet)
}

extension ProteinInfo: Identifiable {
}
