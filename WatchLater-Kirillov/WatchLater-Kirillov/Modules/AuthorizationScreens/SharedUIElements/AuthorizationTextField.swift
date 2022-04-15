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
    
    private var privateType: TextFieldType!
    
    var type: TextFieldType {
        return privateType
    }
    
    init(type: TextFieldType, inset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.inset = inset
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
    
    func addBottomBoarder(color: UIColor, height: CGFloat, sideOffset: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideOffset),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideOffset),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: height)
        ])
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
