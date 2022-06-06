//
//  AuthorizationTextField.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class AuthorizationTextField: BaseTextField {
    
    private var privateType: TextFieldType!
    
    var type: TextFieldType {
        return privateType
    }
    
    init(type: TextFieldType, inset: UIEdgeInsets) {
        super.init(inset: inset)
        let placeholderString: String
        self.privateType = type
        switch type {
        case .email:
            placeholderString = Text.Authorization.Placeholder.email
            clearButtonMode = .whileEditing
            keyboardType = .emailAddress
            isSecureTextEntry = false
            textContentType = .none
            
        case .password:
            placeholderString = Text.Authorization.Placeholder.password
            clearButtonMode = .never
            keyboardType = .default
            isSecureTextEntry = true
            textContentType = .password
            
        case .repeatPassword:
            placeholderString = Text.Authorization.Placeholder.repeatPassword
            clearButtonMode = .never
            keyboardType = .default
            isSecureTextEntry = true
            textContentType = .password
        }
        attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
        textAlignment = .center
        autocapitalizationType = .none
        textColor = Asset.Colors.loginTextColor.color
        autocorrectionType = .no
        returnKeyType = .done
        addBottomBoarder(color: Asset.Colors.textFieldBoarderColor.color,
                         height: LoginScreenSizes.AuthorizationTextField.bottomBoarderLineHeight,
                         sideOffset: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resignFirstResponder() -> Bool {
        if placeholder == nil
            || placeholder!.isEmpty {
            setPlaceholderDependsOnType()
        }
        return super.resignFirstResponder()
    }
    
    func setPlaceholderDependsOnType() {
        let placeholderString: String
        switch type {
        case .email:
            placeholderString = Text.Authorization.Placeholder.email
            
        case .password:
            placeholderString = Text.Authorization.Placeholder.password
            
        case .repeatPassword:
            placeholderString = Text.Authorization.Placeholder.repeatPassword
        }
        attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
    }
}
