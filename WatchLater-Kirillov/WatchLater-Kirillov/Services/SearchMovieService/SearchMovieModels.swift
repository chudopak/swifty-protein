//
//  SearchMovieModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct MoviesResponce: Codable {
    let results: [MovieData]?
    let errorMessage: String?
}

struct MovieData: Codable {
    let id: String
    let image: String
    let title: String
    let description: String
    var rating: String?
    var year: String?
    var isWatched: Bool?
    let genres: [String]?
    
    init(
        id: String,
        image: String,
        title: String,
        description: String,
        rating: String?,
        year: String?,
        isWatched: Bool?,
        genres: [String]?
    ) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.rating = rating
        self.year = year
        self.isWatched = isWatched
        self.genres = genres
    }
    
    init(coreDataType: FilmInfo) {
        id = String(coreDataType.id)
        image = coreDataType.posterID ?? ""
        title = coreDataType.title
        description = coreDataType.titleDescription
        rating = coreDataType.rating
        year = coreDataType.year
        isWatched = coreDataType.isWatched
        genres = coreDataType.genres
    }
}

enum MoviesError: Error {
    case errorFromServer
    
    static var errorMessage = ""
}

extension MoviesError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .errorFromServer:
            return NSLocalizedString(
                MoviesError.errorMessage,
                comment: ""
            )
        }
    }
}

struct Rating: Codable {
    let imDbId: String?
    let year: String?
    let imDb: String?
    let errorMessage: String?
}
