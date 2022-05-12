//
//  DetailsScreenSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum DetailsScreenSizes {
    
    static let buttonsFontSize: CGFloat = 15
    static let buttonsBorderWidth: CGFloat = 2
    static let buttonsCornerRadius: CGFloat = 14
    
    static let scrollViewButtonOffset: CGFloat = 10
    
    enum Poster {
        static let width: CGFloat = 128
        static let height: CGFloat = 200
        static let topOffset: CGFloat = 20
        
        static let noPosterFontSize: CGFloat = 17
    }
    
    enum Title {
        static let height: CGFloat = 52
        static let topOffset: CGFloat = 12
        static let fontSize: CGFloat = 30
    }
    
    enum Year {
        static let fontSize: CGFloat = 16
        static let width: CGFloat = 42
    }
    
    enum Rating {
        static let fontSize: CGFloat = 14
        static let boardWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 11.5
        static let width: CGFloat = 36
    }
    
    enum YearRatingStackView {
        static let height: CGFloat = 23
        static let width: CGFloat = 83
        static let labelsOffset: CGFloat = 5
        static let topOffset: CGFloat = 2
    }
    
    enum ButtonsStack {
        static let height: CGFloat = 28
        static let width: CGFloat = 266
        static let buttonsOffset: CGFloat = 10
        static let topOffset: CGFloat = 16
    }
    
    enum WillWatchButton {
        static let width: CGFloat = 131
    }
    
    enum ViewedButton {
        static let width: CGFloat = 125
    }
    
    enum AddFilmButton {
        static let width: CGFloat = 151
        static let height: CGFloat = 28
        static let topOffset: CGFloat = 16
    }
    
    enum TextView {
        static let topOffset: CGFloat = 32
        static let startHeight: CGFloat = 10
        static let fontSize: CGFloat = 16
        static let sideOffset: CGFloat = 16
        static let width: CGFloat = 292
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
