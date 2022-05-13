//
//  FavouriteModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct FilmsList: Codable {
    let filmDtos: [FilmInfoTmp]?
    let pageCount: Int?
    let size: Int?
}

// TODO: don't forget to add timestamp
struct FilmInfoTmp: Codable, Equatable {
    let id: Int
    let title: String
    let description: String?
    let rating: Double?
    let posterId: String?
    let genres: [String]?
    var isWatched: Bool?
    let timestamp: String?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.id == rhs.id,
              lhs.title == rhs.title
        else {
            return false
        }
        guard optionalsAreEqual(firstVal: lhs.description, secondVal: rhs.description)
                && optionalsAreEqual(firstVal: lhs.rating, secondVal: rhs.rating)
                && optionalsAreEqual(firstVal: lhs.posterId, secondVal: rhs.posterId)
                && optionalsAreEqual(firstVal: lhs.timestamp, secondVal: rhs.timestamp)
                && optionalsAreEqual(firstVal: lhs.genres, secondVal: rhs.genres)
        else {
            return false
        }
        guard let lWatched = lhs.isWatched,
              let rWatched = rhs.isWatched,
              (lWatched && rWatched) || (!lWatched && !rWatched)
        else {
            return false
        }
        return true
    }
}
