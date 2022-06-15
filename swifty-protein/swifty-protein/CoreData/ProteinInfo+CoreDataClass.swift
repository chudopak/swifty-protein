//
//  ProteinInfo+CoreDataClass.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//
//

import Foundation
import CoreData

@objc(ProteinInfo)
public class ProteinInfo: NSManagedObject {
    static func fetchProteinInfo(
        proteinName: String,
        completion: @escaping (ProteinData?) -> Void
    ) {
        let predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(ProteinInfo.name),
            proteinName
        )
        let fetchData = FetchRequestData(
            predicate: predicate,
            fetchLimit: 1
        )
        CoreDataService.shared.get(
                type: ProteinInfo.self,
                fetchRequestData: fetchData
        ) { result in
            switch result {
            case .success(let objects):
                if let obj = objects.first {
                    completion(convertToProteinData(obj: obj))
                    CoreDataService.shared.saveContext()
                } else {
                    completion(nil)
                }
            
            case .failure:
                completion(nil)
            }
        }
    }
    
    static func saveObject(
        proteinData: ProteinData,
        predicate: NSPredicate?
    ) {
        CoreDataService.shared.save(
            with: ProteinInfo.self,
            predicate: nil
        ) { object, managedObjectContext in
            managedObjectContext.performAndWait {
                object.name = proteinData.name
                Element.saveObjects(elements: proteinData.elements, proteinInfo: object, predicate: nil)
            }
        }
    }
    
    private static func convertToProteinData(obj: ProteinInfo) -> ProteinData? {
        guard let objElements = obj.elements?.allObjects as? [Element]
        else {
            return nil
        }
        var elements = [ElementData]()
        for elem in objElements {
            let coordinates = Coordinates(
                x: elem.x,
                y: elem.y,
                z: elem.z
            )
            let elementData = ElementData(
                index: Int(elem.index),
                name: elem.name,
                color: CPKColors.getColor(string: elem.name),
                coordinates: coordinates,
                conections: elem.conections
            )
            elements.append(elementData)
        }
        return ProteinData(name: obj.name, elements: elements)
    }
    
    private static func convertFromProteinData(
        proteinData: ProteinData,
        proteinInfo: ProteinInfo
    ) {
        proteinInfo.name = proteinData.name
        CoreDataService.shared.save(
            with: Element.self,
            predicate: nil,
            amount: proteinData.elements.count
        ) { objects, managedObjectContext in
            managedObjectContext.performAndWait {
                for i in 0..<objects.count {
                    objects[i].name = proteinData.elements[i].name
                    objects[i].index = Int64(proteinData.elements[i].index)
                    objects[i].conections = proteinData.elements[i].conections
                    objects[i].x = proteinData.elements[i].coordinates.x
                    objects[i].y = proteinData.elements[i].coordinates.y
                    objects[i].z = proteinData.elements[i].coordinates.z
                    objects[i].proteinObj = proteinInfo
                }
                proteinInfo.addToElements(NSSet(array: objects))
                CoreDataService.shared.saveContext()
            }
        }
    }
}
