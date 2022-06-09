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
