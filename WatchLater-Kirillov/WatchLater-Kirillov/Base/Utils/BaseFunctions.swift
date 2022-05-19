//
//  BaseFunctions.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/22/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

func decodeMessage<T: Codable>(data: Data?, type: T.Type) -> T? {
    guard let data = data,
          let decoded = try? JSONDecoder().decode(type.self, from: data)
    else {
        return nil
    }
    return decoded
}

func optionalsAreEqual<T: Comparable>(firstVal: T?, secondVal: T?) -> Bool {

    if let firstVal = firstVal, let secondVal = secondVal {
        return firstVal == secondVal
    } else {
        return firstVal == nil && secondVal == nil
   }
}

func optionalsAreEqual<T: Equatable>(firstVal: [T]?, secondVal: [T]?) -> Bool {
    if firstVal == nil && secondVal == nil {
        return true
    }
    guard let oldGenres = firstVal,
          let newGenres = secondVal,
          newGenres.count == oldGenres.count
    else {
        return false
    }
    for i in 0..<oldGenres.count where !(oldGenres[i] == newGenres[i]) {
        return false
    }
    return true
}
