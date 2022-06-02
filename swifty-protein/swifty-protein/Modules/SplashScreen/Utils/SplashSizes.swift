//
//  SplashSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/2/22.
//

import UIKit

enum SplashSizes {
    
    static let duration: TimeInterval = 0.6
    static let delay: TimeInterval = 0.1
    
    enum CenterMolecul {
        static let width: CGFloat = 115
        static let height: CGFloat = 115
    }
    
    enum TopMolecul {
        static let width: CGFloat = 115
        static let height: CGFloat = 115
        
        static let trailingOffset: CGFloat = 50
        static let bottomOffset: CGFloat = 65
    }
    
    enum LeftBottomMolecul {
        static let width: CGFloat = 115
        static let height: CGFloat = 115
        
        static let leadingOffset: CGFloat = 20
        static let topOffset: CGFloat = 25
    }
    
    enum RightBottomMolecul {
        static let width: CGFloat = 115
        static let height: CGFloat = 115
        
        static let trailingOffset: CGFloat = 20
        static let topOffset: CGFloat = 100
    }
}
