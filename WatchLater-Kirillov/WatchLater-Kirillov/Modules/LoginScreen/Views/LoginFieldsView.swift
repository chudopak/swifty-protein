//
//  LoginFieldsView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class LoginFieldsView: UIView, UITextFieldDelegate {
    
    private lazy var emailTextField = makeTextField(
                                        placeholderString: Text.Authorization.Placeholder.email,
                                        viewMode: .whileEditing,
                                        keyboardType: .emailAddress,
                                        isPassword: false)
    private lazy var emailBorderLineView = makeBottomBoarderLine(hight: LoginScreenSizes.FieldsView.bottomBoarderLineHeight)
    
    private lazy var passwordTextField = makeTextField(
                                        placeholderString: Text.Authorization.Placeholder.password,
                                        viewMode: .never,
                                        keyboardType: .default,
                                        isPassword: true)
    private lazy var passwordBorderLineView = makeBottomBoarderLine(hight: LoginScreenSizes.FieldsView.bottomBoarderLineHeight)
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)
        addSubview(emailBorderLineView)
        addSubview(passwordTextField)
        addSubview(passwordBorderLineView)
        setGestures()
        setConstaraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideKeyboard() {
        if emailTextField.isEditing {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isEditing {
            passwordTextField.resignFirstResponder()
        }
    }
    
    private func setGestures() {
        let showKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard(_:)))
        showKeyboardGuesture.cancelsTouchesInView = false
        addGestureRecognizer(showKeyboardGuesture)
    }
    
    @objc private func showKeyboard(_ guestureRecognizer: UIGestureRecognizer) {
        let point = guestureRecognizer.location(in: self)
//        print(point.y)
        if point.y >= LoginScreenSizes.FieldsView.textFieldZoneHeight {
            if passwordTextField.isEditing {
                return
            }
            hideKeyboard()
            passwordTextField.becomeFirstResponder()
        } else {
            if emailTextField.isEditing {
                return
            }
            hideKeyboard()
            emailTextField.becomeFirstResponder()
        }
    }
}

extension LoginFieldsView {
    
    private func makeTextField(placeholderString: String, viewMode: UITextField.ViewMode, keyboardType: UIKeyboardType, isPassword: Bool) -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.clearButtonMode = viewMode
        textField.textColor = Asset.Colors.loginTextColor.color
        textField.autocorrectionType = .no
        textField.keyboardType = keyboardType
        textField.returnKeyType = .done
        textField.isSecureTextEntry = isPassword
        return textField
    }
    
    private func makeBottomBoarderLine(hight: CGFloat) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Asset.Colors.textFieldBoarderColor.color
        return view
    }
}

extension LoginFieldsView {
    
    private func setConstaraints() {
        setEmailTextFieldConstraints()
        setEmailBoarderLineConstraints()
        setPasswordTextFieldConstraints()
        setPasswordBoarderLineConstraints()
    }
    
    private func setEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(LoginScreenSizes.FieldsView.textFieldTopOffset)
            maker.leading.equalTo(layoutMarginsGuide)
            maker.trailing.equalTo(layoutMarginsGuide)
            maker.height.equalTo(LoginScreenSizes.FieldsView.textFieldHeight)
        }
    }
    
    private func setEmailBoarderLineConstraints() {
        emailBorderLineView.snp.makeConstraints { maker in
            maker.top.equalTo(emailTextField.snp.bottom).offset(LoginScreenSizes.FieldsView.bottomBoarderLineTopOffset)
            maker.leading.equalTo(layoutMarginsGuide)
            maker.trailing.equalTo(layoutMarginsGuide)
            maker.height.equalTo(LoginScreenSizes.FieldsView.bottomBoarderLineHeight)
        }
    }
    
    private func setPasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { maker in
            maker.top.equalTo(emailBorderLineView.snp.bottom).offset(LoginScreenSizes.FieldsView.textFieldTopOffset)
            maker.leading.equalTo(layoutMarginsGuide)
            maker.trailing.equalTo(layoutMarginsGuide)
            maker.height.equalTo(LoginScreenSizes.FieldsView.textFieldHeight)
        }
    }
    
    private func setPasswordBoarderLineConstraints() {
        passwordBorderLineView.snp.makeConstraints { maker in
            maker.top.equalTo(passwordTextField.snp.bottom).offset(LoginScreenSizes.FieldsView.bottomBoarderLineTopOffset)
            maker.leading.equalTo(layoutMarginsGuide)
            maker.trailing.equalTo(layoutMarginsGuide)
            maker.height.equalTo(LoginScreenSizes.FieldsView.bottomBoarderLineHeight)
        }
    }
}
