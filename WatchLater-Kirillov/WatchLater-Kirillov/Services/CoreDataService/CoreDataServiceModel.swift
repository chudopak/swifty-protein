//
//  CoreDataServiceModel.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/16/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
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
