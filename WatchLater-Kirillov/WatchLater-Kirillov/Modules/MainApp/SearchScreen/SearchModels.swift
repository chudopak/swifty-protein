//
//  SearchModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct SearchText {
    var previous: String
    var current: String
}

enum SearchArea {
    case IMDB, local
}
