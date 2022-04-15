//
//  AuthorizationTextField.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class AuthorizationTextField: UITextField {
    
    private var inset: UIEdgeInsets!
    
    init(inset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.inset = inset
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -inset.left, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: inset)
    }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: inset)
    }
    
    static func makeTextField(type: TextFieldType, inset: UIEdgeInsets) -> AuthorizationTextField {
        let textField = AuthorizationTextField(inset: inset)
        let placeholderString: String
        switch type {
        case .email:
            placeholderString = Text.Authorization.Placeholder.email
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .emailAddress
            textField.isSecureTextEntry = false
            textField.textContentType = .none

        case .password:
            placeholderString = Text.Authorization.Placeholder.password
            textField.clearButtonMode = .never
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.textContentType = .password

        case .repeatPassword:
            placeholderString = Text.Authorization.Placeholder.repeatPassword
            textField.clearButtonMode = .never
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.textContentType = .password
        }
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.textColor = Asset.Colors.loginTextColor.color
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.addBottomBoarder(color: Asset.Colors.textFieldBoarderColor.color,
                                   height: LoginScreenSizes.AuthorizationTextField.bottomBoarderLineHeight,
                                   sideOffset: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset)
        return textField
    }
}
