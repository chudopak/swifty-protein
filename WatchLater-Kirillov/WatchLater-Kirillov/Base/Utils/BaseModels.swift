//
//  BaseModels.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct Tokens: Codable {
    let accessToken: String
    let refreshToken: String
}

enum BaseError: Error {
    case imageLoadingError
    case noResponse
    case unownedResponseCode
}

extension BaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageLoadingError:
            return NSLocalizedString(
                "Can not download image.",
                comment: ""
            )
        
        case .noResponse:
            return NSLocalizedString(
                "No response provided in request.",
                comment: ""
            )
            
        case .unownedResponseCode:
            return NSLocalizedString(
                "Unowned Response Code.",
                comment: ""
            )
        }
    }
}
