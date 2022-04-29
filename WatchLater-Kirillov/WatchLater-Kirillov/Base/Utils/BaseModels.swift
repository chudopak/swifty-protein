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

struct ImageData: Codable {
    let data: Data
}

enum BaseError: Error {
    case imageLoadingError
    case noResponse
    case unownedResponseCode
    case failedToBuildRequest
    case noData
    case range400Response
    case unableToDecodeData
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
        
        case .failedToBuildRequest:
            return NSLocalizedString(
                "Failed to build request.",
                comment: ""
            )
            
        case .noData:
            return NSLocalizedString(
                "There is no data in response.",
                comment: ""
            )
            
        case .range400Response:
            return NSLocalizedString(
                "Response in 400's range.",
                comment: ""
            )
            
        case .unableToDecodeData:
            return NSLocalizedString(
                "Can not decode data to needed type.",
                comment: ""
            )
        }
    }
}
