//
//  CoreDataModel.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//

import UIKit

struct FetchRequestData {
    let predicate: NSPredicate?
    let sortDescriptors: [NSSortDescriptor]?
    let fetchLimit: Int
    let fetchOffset: Int
    
    init(predicate: NSPredicate?,
         sortDescriptors: [NSSortDescriptor]? = nil,
         fetchLimit: Int = .zero,
         fetchOffset: Int = .zero) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
    }
}
