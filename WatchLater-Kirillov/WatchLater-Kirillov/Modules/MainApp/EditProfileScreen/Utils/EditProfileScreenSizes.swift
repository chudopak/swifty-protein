//
//  EditProfileScreenSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum EditProfileScreenSize {
    
    static let scrollViewButtonOffset: CGFloat = 10
    static let emtyViewHeight: CGFloat = 0.1
    
    enum UploadPhotoButton {
        static let width: CGFloat = 120
        static let height: CGFloat = 120
        static let cornerRadius: CGFloat = 14
        static let uploadImageHeight: CGFloat = 20
        static let uploadImageWidth: CGFloat = 17
        static let labelHeight: CGFloat = 44
        static let labelFontSize: CGFloat = 17
        
        static let topOffset: CGFloat = 70
        static let imageTopOffset: CGFloat = 25
        static let labelBottomOffset: CGFloat = 25
    }
    
    enum ProfileImage {
        static let buttonWidth: CGFloat = 20
        static let buttonHeight: CGFloat = 20
        static let buttonTopOffset: CGFloat = 7
        static let buttonRightOffset: CGFloat = 8
        static let borderWidth: CGFloat = 2
        
        static let imageSideOffset: CGFloat = 70
        static let imageWidth: CGFloat = 160
        static let imageHeight: CGFloat = 135
        static let imageTopOffset: CGFloat = 56
    }
    
    enum TextField {
        
        private static let ratioSideOffsetWithScreenWidth: CGFloat = 0.042
        
        static let height: CGFloat = 60
        static let topOffset: CGFloat = 57
        static let bottomBoarderLineHeight: CGFloat = 0.5
        static var textRectangleTopOffset: CGFloat = 19
        static var textRectangleSideOffset: CGFloat {
            return UIScreen.main.bounds.size.width * ratioSideOffsetWithScreenWidth
        }
    }
}
