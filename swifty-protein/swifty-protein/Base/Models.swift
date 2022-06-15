//
//  Models.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/7/22.
//

import UIKit

enum BiometryType {
    case faceID
    case touchID
    case none
}

enum SFSymbols {
    static let touchId = "touchid"
    static let faceId = "faceid"
    static let deleteLeft = "delete.left"
}

enum NavigationBarTitleView {
    static let width: CGFloat = 42
    static let height: CGFloat = 42
}

enum BaseError: Error {
    case canNotBuildUrl(String)
    case range400Response(String, Int)
    case noData(String)
    case canNotParseProteinData(String)
    case unownedError(String)
}

extension BaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .canNotBuildUrl(let errorPlace):
            return NSLocalizedString(
                "\(errorPlace) - can not build url",
                comment: ""
            )
            
        case let .range400Response(errorPlace, code):
            return NSLocalizedString(
                "\(errorPlace) - server response code - \(code)",
                comment: ""
            )
            
        case .noData(let errorPlace):
            return NSLocalizedString(
                "\(errorPlace) - no data in response",
                comment: ""
            )
        
        case .canNotParseProteinData(let errorPlace):
            return NSLocalizedString(
                "\(errorPlace) - can not parse protein data, something bad with format",
                comment: ""
            )
            
        case .unownedError(let errorPlace):
            return NSLocalizedString(
                "\(errorPlace) - unowned error",
                comment: ""
            )
        }
    }
}
