//
//  LoginScreenElementsSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum LoginScreenSizes {
    
    enum WatchLaterLogo {

        private static let ratioWatchLaterWithScreenWidth: CGFloat = 0.261
        private static let ratioWatchLaterHeightWithWatchLaterWidth: CGFloat = 0.428
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.194
        
        static var width: CGFloat {
            return (UIScreen.main.bounds.size.width * ratioWatchLaterWithScreenWidth)
        }
        static var height: CGFloat {
            return (width * ratioWatchLaterHeightWithWatchLaterWidth)
        }
        static var topOffset: CGFloat {
            return (UIScreen.main.bounds.size.height * ratioTopOffsetToScreenHeight)
        }
    }
    
    enum FieldsView {
        
        private static let ratioTextFieldWidthWithScreenWidth: CGFloat = 0.945
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.137
        
        static let width: CGFloat = UIScreen.main.bounds.size.width
        static let height: CGFloat = 120
        static var topOffset: CGFloat {
            return (ratioTopOffsetToScreenHeight * UIScreen.main.bounds.size.height)
        }
        static let bottomBoarderLineHeight: CGFloat = 0.5
        static var bottomBoarderLineTopOffset: CGFloat {
            return (textFieldTopOffset - bottomBoarderLineHeight)
        }
        static var textFieldHeight: CGFloat = 22
        static var textFieldTopOffset: CGFloat = 19
        static var textFieldZoneHeight: CGFloat {
            return (height / 2)
        }
    }
}
