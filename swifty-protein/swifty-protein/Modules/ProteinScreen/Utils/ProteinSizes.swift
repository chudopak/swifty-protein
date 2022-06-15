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
}
