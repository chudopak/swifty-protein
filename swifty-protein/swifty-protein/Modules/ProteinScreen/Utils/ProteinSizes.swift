//
//  ProteinSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/14/22.
//

import UIKit

enum ProteinSizes {
    
    enum Molecule {
        static let sphereRadius: CGFloat = 0.4
        static let cylinderRadius: CGFloat = 0.1
    }
    
    enum Camera {
        static let minStartHeight: Double = 7
        static let farDepthLimitOffsetFromStartHeight: Double = 30
        static let reserveToFitAllAtoms: Double = 2
    }
    
    enum Spinner {
        static let width: CGFloat = 40
        static let height: CGFloat = 40
    }
    
    enum ErrorView {
        static let width: CGFloat = 260
        static let height: CGFloat = 300
        static let errorTitileFontSize: CGFloat = 25
        static let errorDescriptionFontSize: CGFloat = 17
        
        static let buttonCornerRadius: CGFloat = 7
        static var buttonWidth: CGFloat {
            return width * 0.8
        }
        static let buttonHeight: CGFloat = 50
        
        static let imageViewSize: CGFloat = 90
        
        static let titleHeight: CGFloat = 50
        static let titleTopOffset: CGFloat = 10
        
        static let descriptionOffset: CGFloat = 10
    }
}
