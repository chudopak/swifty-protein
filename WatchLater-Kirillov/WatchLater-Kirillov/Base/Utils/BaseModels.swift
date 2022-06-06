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
    case cancelled
    case badResult
}

extension BaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageLoadingError:
            return NSLocalizedString(
                Text.BaseError.imageLoadingError,
                comment: ""
            )
        
        case .noResponse:
            return NSLocalizedString(
                Text.BaseError.noResponse,
                comment: ""
            )
            
        case .unownedResponseCode:
            return NSLocalizedString(
                Text.BaseError.unownedResponseCode,
                comment: ""
            )
        
        case .failedToBuildRequest:
            return NSLocalizedString(
                Text.BaseError.failedToBuildRequest,
                comment: ""
            )
            
        case .noData:
            return NSLocalizedString(
                Text.BaseError.noData,
                comment: ""
            )
            
        case .range400Response:
            return NSLocalizedString(
                Text.BaseError.range400Response,
                comment: ""
            )
            
        case .unableToDecodeData:
            return NSLocalizedString(
                Text.BaseError.unableToDecodeData,
                comment: ""
            )
        
        case .cancelled:
            return NSLocalizedString(
                Text.BaseError.cancelled,
                comment: ""
            )
            
        case .badResult:
            return NSLocalizedString(
                Text.BaseError.badResult,
                comment: ""
            )
        }
    }
}

enum SearchArea {
    case IMDB
    case local
}
