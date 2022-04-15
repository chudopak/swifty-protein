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
            return UIScreen.main.bounds.size.width * ratioWatchLaterWithScreenWidth
        }
        static var height: CGFloat {
            return width * ratioWatchLaterHeightWithWatchLaterWidth
        }
        static var topOffset: CGFloat {
            return UIScreen.main.bounds.size.height * ratioTopOffsetToScreenHeight
        }
    }
    
    enum AuthorizationTextField {
        
        private static let ratioSideOffsetWithScreenWidth: CGFloat = 0.042
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.137
        
        static let width: CGFloat = UIScreen.main.bounds.size.width
        static let height: CGFloat = 60
        static var topOffset: CGFloat {
            return ratioTopOffsetToScreenHeight * UIScreen.main.bounds.size.height
        }
        static let bottomBoarderLineHeight: CGFloat = 0.5
        static var textRectangleTopOffset: CGFloat = 19
        static var textRectangleSideOffset: CGFloat {
            return UIScreen.main.bounds.size.width * ratioSideOffsetWithScreenWidth
        }
    }
    
    enum AuthorizationButton {
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.137
        
        static let width: CGFloat = 149
        static let height: CGFloat = 50
        static let borderWidth: CGFloat = 4
        static var cornerRadius: CGFloat {
            return height * 0.5
        }
        static var topOffset: CGFloat {
            return ratioTopOffsetToScreenHeight * UIScreen.main.bounds.size.height
        }
        static let fontSize: CGFloat = 17
    }
    
    enum RegistrationButton {
        private static let ratioButtonWithScreenWidth: CGFloat = 0.915
        private static let ratioTopOffsetToScreenHeight: CGFloat = 0.064
        
        static let height: CGFloat = 20
        static let fontSize: CGFloat = 15
        static var width: CGFloat {
            return UIScreen.main.bounds.size.width * ratioButtonWithScreenWidth
        }
        static var topOffset: CGFloat {
            return UIScreen.main.bounds.size.height * ratioTopOffsetToScreenHeight
        }
    }
    
    enum LoginFailedLabel {
        
        private static let ratioLabelWithScreenWidth: CGFloat = 0.915
        
        static let height: CGFloat = 18
        static var width: CGFloat {
            return UIScreen.main.bounds.size.width * ratioLabelWithScreenWidth
        }
        static let topOffset: CGFloat = 17.5
        static let fontSize: CGFloat = 13
    }
}
