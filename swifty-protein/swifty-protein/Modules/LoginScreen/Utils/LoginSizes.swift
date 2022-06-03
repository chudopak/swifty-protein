//
//  LoginSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

enum LoginSizes {
    
    static let passwordLength = 5
    
    enum KeboardView {
        static let widthMultiplyer: CGFloat = 0.8
        static let height: CGFloat = 355
    }
    
    enum KeboardButton {
        static let width: CGFloat = 70
        static let height: CGFloat = 70
        static let cornerRadius: CGFloat = 35
        static let boarderWidth: CGFloat = 2
        
        static let sideOffset: CGFloat = 25
    }
    
    enum DeleteButton {
        static let verticalInset: CGFloat = 15
        static let horizontalInset: CGFloat = 10
    }
    
    enum PasswordStack {
        static let width: CGFloat = 110
        static let bottom: CGFloat = 30
        static let height: CGFloat = 14
        static let spacing: CGFloat = 10
    }
    
    enum PasswordDotLabel {
        static let width: CGFloat = 14
        static let height: CGFloat = 14
        static let cornerRadius: CGFloat = 7
        static let boarderWidth: CGFloat = 1
    }
}
