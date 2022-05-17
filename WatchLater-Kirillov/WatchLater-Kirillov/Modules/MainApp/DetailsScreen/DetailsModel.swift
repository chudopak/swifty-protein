//
//  DetailsModel.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum ImageLinkType {
    case IMDB(String)
    case local(String)
}

struct MovieDetails: Equatable {
    let imageType: ImageLinkType
    let rating: String
    let year: String
    let description: String
    let genres: [String]?
    let title: String
    var isWatched: Bool?
    let id: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.year == rhs.year
                && lhs.rating == rhs.rating
                && lhs.description == rhs.description
                && optionalsAreEqual(firstVal: lhs.genres, secondVal: rhs.genres)
                && lhs.title == rhs.title
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
