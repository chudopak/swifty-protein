//
//  ProfileModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct UserInfo {
    let id: Int
    let name: String
    let description: String
    let genres: [String]
    let photoId: String
    
    init(id: Int,
         name: String,
         description: String,
         genres: [String],
         photoId: String
    ) {
        self.id = id
        self.name = name
        self.genres = genres
        self.photoId = photoId
        self.description = description
    }
    
    init(pofileCoreDataInfo: ProfileInfo) {
        self.id = Int(pofileCoreDataInfo.id)
        self.name = pofileCoreDataInfo.name
        self.genres = pofileCoreDataInfo.genres
        self.photoId = pofileCoreDataInfo.photoId
        self.description = pofileCoreDataInfo.aboutMe
    }
}

struct UserInfoBackground: Codable {
    let photoId: String?
}
