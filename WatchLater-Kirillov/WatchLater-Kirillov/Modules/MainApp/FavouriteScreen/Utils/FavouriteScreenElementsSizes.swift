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
    }
    
    enum FilmsView {
        static let ratioWithSuperViewWidth: CGFloat = 0.915
        static let topOffset: CGFloat = 18
    }
}
