//
//  FavouriteModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct FilmsList: Codable {
    let filmDtos: [FilmData]?
    let pageCount: Int?
    let size: Int?
}

struct FilmData: Codable, Equatable {
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
        let lYear = getPrefix(string: lhs.timestamp ?? "1970", prefixValue: 4)
        let rYear = getPrefix(string: rhs.timestamp ?? "1970", prefixValue: 4)
        let lRating = getPrefix(string: String(lhs.rating ?? 0), prefixValue: 3)
        let rRating = getPrefix(string: String(rhs.rating ?? 0), prefixValue: 3)
        guard optionalsAreEqual(firstVal: lhs.description, secondVal: rhs.description)
                && lRating == rRating
                && optionalsAreEqual(firstVal: lhs.posterId, secondVal: rhs.posterId)
                && optionalsAreEqual(firstVal: lhs.genres, secondVal: rhs.genres)
                && lYear == rYear
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

struct FilmsPaging {
    var currentPage: Int
    var isFull: Bool
    var lastPageSize: Int
}

enum EditedFilmInfo {
    case deleted(Int)
    case cangedWatchStatus(FilmData)
}
