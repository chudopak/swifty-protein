//
//  LoginSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

enum LoginSizes {
    
    static let passwordLength = 5
    
    enum KeyboardView {
        static let width: CGFloat = 256
        static let height: CGFloat = 355
        static let centerYOffset: CGFloat = 30
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
    }
    
    enum RestorePasswordButton {
        static let width: CGFloat = 230
        static let height: CGFloat = 50
        static let topOffset: CGFloat = 20
        static let fontSize: CGFloat = 19
    }
}
