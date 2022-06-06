//
//  RegistrationSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/6/22.
//

import UIKit

enum RegistrationSizes {
    
    static let passwordLength = 5
    
    enum KeyboardView {
        static let width: CGFloat = 256
        static let height: CGFloat = 355
        static let centerYOffset: CGFloat = 30
    }
    
    enum KeyboardButton {
        static let width: CGFloat = 70
        static let height: CGFloat = 70
        static let cornerRadius: CGFloat = 35
        static let boarderWidth: CGFloat = 2
        
        static let sideOffset: CGFloat = 20
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
    
    enum InputPasswordLabel {
        static let height: CGFloat = 18
        static let bottomOffset: CGFloat = 10
        static let shakeOffset: CGFloat = 10
    }
    
    enum SavePasswordButton {
        static let width: CGFloat = 150
        static let height: CGFloat = 22
        static let topOffset: CGFloat = 20
    }
}
