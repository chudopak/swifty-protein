//
//  FavouriteModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct FilmInfo: Codable {
    let id: String
    let resultType: String
    let image: String
    let title: String
    let description: String
}
