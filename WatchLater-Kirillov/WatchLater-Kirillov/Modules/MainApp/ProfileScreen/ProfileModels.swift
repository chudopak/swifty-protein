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
    var photoId: String
    var photoData: Data?
    
    init(id: Int,
         name: String,
         description: String,
         genres: [String],
         photoId: String,
         photoData: Data?
    ) {
        self.id = id
        self.name = name
        self.genres = genres
        self.photoId = photoId
        self.description = description
        self.photoData = photoData
    }
    
    init(pofileCoreDataInfo: ProfileInfo) {
        self.id = Int(pofileCoreDataInfo.id)
        self.name = pofileCoreDataInfo.name
        self.genres = pofileCoreDataInfo.genres
        self.photoId = pofileCoreDataInfo.photoId
        self.description = pofileCoreDataInfo.aboutMe
        self.photoData = pofileCoreDataInfo.photoData
    }
}

struct UserInfoBackground: Codable {
    let photoId: String?
}

struct ProfileImageData: Codable {
    let id: String
    let image: ImageData
}
