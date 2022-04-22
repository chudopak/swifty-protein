//
//  SplashScreenSizes.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/14/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum SplashScreenSizes {
    private static let ratioScreenWithWatchLaterWidths: CGFloat = 0.527_2
    private static let ratioWatchLaterHeightWithWatchLaterWidth: CGFloat = 0.434_0
    private static let ratioEyeSideWithWatchLaterHeight: CGFloat = 0.410_9
    private static let ratioEyeTopOffsetWithWatchLaterHeight: CGFloat = 0.309_6
    private static let ratioEyeLeftOffsetWithWatchLeterWidthCenter: CGFloat = 0.431_5
    private static let ratioEyeLeftOffsetWithWatchLeterWidthRight: CGFloat = 0.482_0
    private static let ratioEyeLeftOffsetWithWatchLeterWidthLeft: CGFloat = 0.390_9
    private static let ratioScreenWithAgonaWidth: CGFloat = 0.245_3
    private static let ratioAgonaHeightWithAgonaWidth: CGFloat = 0.467_4
    private static let ratioAgonaBottomOffsetToScreenHeight: CGFloat = 0.094_8
    
    static let sizeRatioBeforeAnimation: CGFloat = 0.8
    
    static var watchLaterImageViewWidth: CGFloat {
        return (UIScreen.main.bounds.size.width * ratioScreenWithWatchLaterWidths)
    }
    static var watchLaterImageViewHeight: CGFloat {
        return (UIScreen.main.bounds.size.width * ratioScreenWithWatchLaterWidths * ratioWatchLaterHeightWithWatchLaterWidth)
    }
    static var eyeImageViewSide: CGFloat {
        return (watchLaterImageViewHeight * ratioEyeSideWithWatchLaterHeight)
    }
    static var eyeImageViewXCenter: CGFloat {
        return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthCenter)
    }
    static var eyeImageViewXRight: CGFloat {
        return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthRight)
    }
    static var eyeImageViewXLeft: CGFloat {
        return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthLeft)
    }
    static var eyeImageViewY: CGFloat {
        return (watchLaterImageViewHeight * ratioEyeTopOffsetWithWatchLaterHeight)
    }
    static var agonaImageViewWidth: CGFloat {
        return (UIScreen.main.bounds.size.width * ratioScreenWithAgonaWidth)
    }
    static var agonaImageViewHeight: CGFloat {
        return (agonaImageViewWidth * ratioAgonaHeightWithAgonaWidth)
    }
    static var agonaImageViewBottomOffset: CGFloat {
        return (UIScreen.main.bounds.size.height * ratioAgonaBottomOffsetToScreenHeight)
    }
}

enum SplashScreenAnimation {
    
    enum FadeIn {
        static let duration: TimeInterval = 0.7
        static let delay: TimeInterval = .zero
        static let alpha: CGFloat = 1.0
    }
    
    enum PhaseOne {
        static let duration: TimeInterval = 0.5
        static let delay: TimeInterval = .zero
    }
    
    enum PhaseTwo {
        static let duration: TimeInterval = 0.5
        static let delay: TimeInterval = 0.1
    }
    
    enum PhaseThree {
        static let duration: TimeInterval = 0.5
        static let delay: TimeInterval = 0.1
    }
}
