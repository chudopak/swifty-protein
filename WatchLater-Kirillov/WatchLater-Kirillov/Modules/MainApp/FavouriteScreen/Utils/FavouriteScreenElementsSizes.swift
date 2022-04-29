//
//  FavouriteScreenElementsSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum FavouriteScreenSizes {

    enum SegmentControl {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let height: CGFloat = 32
        static let topOffset: CGFloat = 18
    }
    
    enum FilmCollectionViewCell {
        static let ratioWithSuperViewWidth: CGFloat = 0.305
        static let ratioSelfWidthWithHeight: CGFloat = 1.8
        static let ratioFilmImageHeightWithCellHeight: CGFloat = 0.8
        static let ratioTitleLabelHeightWithCellHeight: CGFloat = 0.14
        static let ratingBorderWidth: CGFloat = 1
        static let ratingHeight: CGFloat = 15
        static let ratingWidth: CGFloat = 24
        static let fontSize: CGFloat = 12
        static let ratingTopOffset: CGFloat = 7
        static let ratingRightOffset: CGFloat = 4.5
        static let noImageLabelSideOffset: CGFloat = 5
    }
    
    enum FilmsView {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let topOffset: CGFloat = 18
    }
    
    enum FilmsTableViewCell {
        static let trailingAccessoryZoneInset: CGFloat = 10
        static let height: CGFloat = 22
    }
}
