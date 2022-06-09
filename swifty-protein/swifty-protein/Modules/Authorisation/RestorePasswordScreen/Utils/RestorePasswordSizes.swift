//
//  RestorePasswordSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

enum RestorePasswordSizes {
    
    static let passwordLength = 5
    
    enum KeyboardView {
        static let width: CGFloat = 256
        static let height: CGFloat = 355
        static let centerYOffset: CGFloat = 45
    }
    
    enum SavePasswordButton {
        static let width: CGFloat = 150
        static let height: CGFloat = 22
        static let topOffset: CGFloat = 20
    }
    
    enum AnswerTextField {
        static let widthMultiplyer: CGFloat = 0.8
        static let height: CGFloat = 40
        static let cornerRadius: CGFloat = 5
        static let boarderWidth: CGFloat = 1
    }
    
    enum SaveAnswerButton {
        static let widthMultiplyer: CGFloat = 0.8
        static let height: CGFloat = 40
        static let cornerRadius: CGFloat = 5
    }
    
    enum QuestionStackView {
        static let widthMultiplyer: CGFloat = 0.8
        static let height: CGFloat = 140
        static let spacing: CGFloat = 10
    }
    
    enum InputPasswordLabel {
        static let height: CGFloat = 18
        static let bottomOffset: CGFloat = 10
        static let shakeOffset: CGFloat = 10
        static let shakeDuration: TimeInterval = 0.07
        static let shareRepeatings: Float = 4
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
