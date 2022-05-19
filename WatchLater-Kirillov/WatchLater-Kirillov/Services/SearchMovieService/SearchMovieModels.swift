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
