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

struct MovieDetails {
    let imageType: ImageLinkType
    let rating: String
    let year: String
    let description: String
    let genres: [String]?
    let title: String
    var isWatched: Bool?
}
