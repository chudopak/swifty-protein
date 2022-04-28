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

struct FilmInfoTmp: Codable {
    let id: Int
    let title: String
    let description: String?
    let rating: Double?
    let posterId: String?
    let geners: [String]?
}
