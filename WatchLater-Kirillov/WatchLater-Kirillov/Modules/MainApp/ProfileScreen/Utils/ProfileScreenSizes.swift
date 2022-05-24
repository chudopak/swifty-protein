//
//  ProfileScreenSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum ProfileScreenSizes {
    
    static let emtyViewHeight: CGFloat = 0.3
    static let scrollViewBottomOffset: CGFloat = 10
    
    enum Picture {
        static let height: CGFloat = 209
        static let width: CGFloat = 209
        static let cornerRadius: CGFloat = 104.5
        static let topOffset: CGFloat = 29
        static let labelFontSize: CGFloat = 17
        static let labelHeight: CGFloat = 40
    }
    
    enum Name {
        static let height: CGFloat = 52
        static let topOffset: CGFloat = 12
        static let fontSize: CGFloat = 30
    }
    
    enum Description {
        static let fontSize: CGFloat = 16
        static let topOffset: CGFloat = 4
        static let startHeight: CGFloat = 5
        static let width: CGFloat = 292
        static let maxCharacter = 1_000
    }
    
    enum FavouriteGanresTitle {
        static let topOffset: CGFloat = 10
        static let height: CGFloat = 25
        static let width: CGFloat = 293
        static let fontSize: CGFloat = 24
    }
    
    enum Genres {
        static let maxWidth: CGFloat = UIScreen.main.bounds.size.width - 20
        static let stackHeight: CGFloat = 28
        static let stackTopOffset: CGFloat = 16
        static let labelCornerRadius: CGFloat = 14
        static let labelFontSize: CGFloat = 15
        static let labelBoardWidth: CGFloat = 2
        static let maxCharsInLabel = 25
        static let labelSpace: CGFloat = 10
    }
}
