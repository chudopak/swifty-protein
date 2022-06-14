//
//  Element+CoreDataClass.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//
//

import Foundation
import CoreData

@objc(Element)
public class Element: NSManagedObject {
    
    static func saveObjects(
        elements: [ElementData],
        proteinInfo: ProteinInfo,
        predicate: NSPredicate?
    ) {
        CoreDataService.shared.save(
            with: Element.self,
            predicate: nil,
            amount: elements.count
        ) { objects, managedObjectContext in
            managedObjectContext.performAndWait {
                for i in 0..<objects.count {
                    objects[i].name = elements[i].name
                    objects[i].index = Int64(elements[i].index)
                    objects[i].conections = elements[i].conections
                    objects[i].x = elements[i].coordinates.x
                    objects[i].y = elements[i].coordinates.y
                    objects[i].z = elements[i].coordinates.z
                    objects[i].proteinObj = proteinInfo
                }
                proteinInfo.addToElements(NSSet(array: objects))
                CoreDataService.shared.saveContext()
            }
        }
    }
}
