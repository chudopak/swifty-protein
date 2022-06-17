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
    
    enum AtomDetails {
        static let springWithDamping: CGFloat = 0.7
        static let springVelocity: CGFloat = 1
        
        static let hegiht: CGFloat = 250
        static let cornerRadius: CGFloat = 15
        static let bottomOffset: CGFloat = 20
        static let animationDuration: TimeInterval = 0.5
        static let elementsSideOffset: CGFloat = 20
        static let fontSize: CGFloat = 15
        static let errorFontSize: CGFloat = 22
        static let panAnimationDuration: TimeInterval = 0.2
        
        static let symbolSize: CGFloat = 70
        static let symbolFontSize: CGFloat = 60
        
        static let atomNameFontSize: CGFloat = 15
        static let atomNameHeight: CGFloat = 20
        static let atomNameWidth: CGFloat = 100
        
        static let atomNumberSize: CGFloat = 20
        static let atomNumberFontSize: CGFloat = 17
        
        static let containerSize: CGFloat = 100
        static let containerTopOffset: CGFloat = 20
        static let containerLeadingOffset: CGFloat = 20
        static let containerCornerRadius: CGFloat = 10
        static let containerElementsSideOffset: CGFloat = 5
        
        static let stackHeight: CGFloat = 40
        static let stackSuperViewTopOffset: CGFloat = 20
        static let stackTopOffset: CGFloat = 17.5
        static let stackVerticalSpace: CGFloat = 5
        static let stackHorizontalSpace: CGFloat = 5
        
        static let auxiliaryStackHeight: CGFloat = 52.5
        
        static let dragViewButtonHeight: CGFloat = 20
        static let dragViewLabelHeight: CGFloat = 5
        static let dragViewLabelWidth: CGFloat = 50
        static let dragViewLabelCornerRadius: CGFloat = 2.5
    }
}
