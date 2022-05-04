//
//  SearchScreenSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/4/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum SearchScreenSizes {
    
    enum SegmentControl {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let height: CGFloat = 32
        static let topOffset: CGFloat = 18
    }
    
    enum TextField {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let height: CGFloat = 36
        static let topOffset: CGFloat = 18
        static let cornerRadius: CGFloat = 10
        static let searchImageViewSize = CGSize(width: 16, height: 16)
        static let searchImageContainerViewRect = CGRect(x: 0, y: 0, width: 32, height: 36)
    }
    
    enum StartTypingLabel {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let height: CGFloat = 40
        static let topOffset: CGFloat = 24
        static let fontSize: CGFloat = 15
    }
    
    enum TableView {
        static let topOffset: CGFloat = 18
        static let cellHeight: CGFloat = 101
        
        static let posterImageViewHeight: CGFloat = 81
        static let posterImageViewWidth: CGFloat = 52
        static let posterImageViewSideOffset: CGFloat = 10
        
        static let titleFontSize: CGFloat = 17
        static let yearFontSize: CGFloat = 12
        
        static let stackViewHeight: CGFloat = 46
        static let stackViewOffset: CGFloat = 10

        static let ratingBorderWidth: CGFloat = 1
        static let ratingHeight: CGFloat = 15
        static let ratingWidth: CGFloat = 24
        static let fontSize: CGFloat = 12
        static let ratingTopOffset: CGFloat = 5
        static let ratingLeftOffset: CGFloat = 10
    }
}
