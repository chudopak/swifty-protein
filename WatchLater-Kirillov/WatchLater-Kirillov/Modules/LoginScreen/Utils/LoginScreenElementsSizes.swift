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
    
    enum EmailField {

        private static let ratioWidthWithHeight: CGFloat = 0.160
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.137
        
        static let width: CGFloat = UIScreen.main.bounds.size.width
        static let bottomBoarderLineHeight: CGFloat = 0.5
        static var height: CGFloat {
            return (width * ratioWidthWithHeight)
        }
        static var topOffset: CGFloat {
            return (UIScreen.main.bounds.size.height * ratioTopOffsetToScreenHeight)
        }
    }
}
