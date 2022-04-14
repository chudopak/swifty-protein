//
//  LoginViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    private lazy var watchLaterLogoImageView = makeWatchLaterLogoImageView()
    private lazy var emailTextField = makeTextField(type: .email)
    private lazy var passwordTextField = makeTextField(type: .password)
    private lazy var loginButton = makeLoginButton()
    
    private var isFieldsSet: Bool {
        return emailTextField.text != nil
            && !emailTextField.text!.isEmpty
            && passwordTextField.text != nil
            && !passwordTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(watchLaterLogoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        setGestures()
        setConstraints()
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    private func getLoginData() -> LoginData? {
        guard isFieldsSet
        else {
            return nil
        }
        return LoginData(password: passwordTextField.text!, email: emailTextField.text!)
    }
    
    @objc private func hideKeyboard() {
        if emailTextField.isEditing {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isEditing {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @objc private func emailTextFieldDonePressed() {
        emailTextField.resignFirstResponder()
        if let loginData = getLoginData() {
            // Do request
            print(loginData)
        } else if emailTextField.text != nil
                    && !emailTextField.text!.isEmpty {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    @objc private func passwordTextFieldDonePressed() {
        passwordTextField.resignFirstResponder()
        if let loginData = getLoginData() {
            // Do request
            print(loginData)
        } else if passwordTextField.text != nil
                    && !passwordTextField.text!.isEmpty {
            emailTextField.becomeFirstResponder()
        }
    }
    
    @objc private func loginButtonTaped() {
        hideKeyboard()
        if let loginData = getLoginData() {
            // Do request
            print(loginData)
        }
    }
    
    @objc private func textFieldDidChange() {
        if isFieldsSet && !loginButton.isEnabled {
            loginButton.isEnabled = true
        } else if !isFieldsSet && loginButton.isEnabled {
            loginButton.isEnabled = false
        }
    }
}

// MARK: Extension for element creation
extension LoginViewController {
    
    private func makeWatchLaterLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: Asset.watchLaterLogoFull.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeTextField(type: TextFieldType) -> AuthorizationTextField {
        let inset = UIEdgeInsets(top: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                                 left: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset,
                                 bottom: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                                 right: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset)
        let textField = AuthorizationTextField.makeTextField(type: type, inset: inset)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        switch type {
        case .email:
            textField.addTarget(self, action: #selector(emailTextFieldDonePressed), for: .editingDidEndOnExit)
        
        case .password:
            textField.addTarget(self, action: #selector(passwordTextFieldDonePressed), for: .editingDidEndOnExit)

        default:
            break
        }
        return textField
    }
    
    private func makeLoginButton() -> AuthorizationButton {
        let colorSet = AuthorizationButtonColorSet(
                                    enabledText: Asset.Colors.enabledAuthorizationButtonText.color,
                                    enabledBackground: .clear,
                                    enabledBorder: Asset.Colors.enabledAuthorizationButtonBorderLine.color,
                                    disabledText: Asset.Colors.disabledAuthorizationButtonText.color,
                                    disabledBackground: Asset.Colors.disabledAuthorizationButtonBackground.color,
                                    disabledBorder: .clear)
        let button = AuthorizationButton(colorSet: colorSet, text: Text.Common.login)
        button.addTarget(self, action: #selector(loginButtonTaped), for: .touchUpInside)
        return button
    }
}

// MARK: Constraints
extension LoginViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldConstraints()
        setLoginButtonConstraints()
    }
    
    private func setWatchLaterLogoConstraints() {
        watchLaterLogoImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(LoginScreenSizes.WatchLaterLogo.topOffset)
            maker.width.equalTo(LoginScreenSizes.WatchLaterLogo.width)
            maker.height.equalTo(LoginScreenSizes.WatchLaterLogo.height)
        }
    }
    
    private func setEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(watchLaterLogoImageView).inset(LoginScreenSizes.AuthorizationTextField.topOffset)
            maker.width.equalTo(LoginScreenSizes.AuthorizationTextField.width)
            maker.height.equalTo(LoginScreenSizes.AuthorizationTextField.height)
        }
    }
    
    private func setPasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(emailTextField.snp.bottom)
            maker.width.equalTo(LoginScreenSizes.AuthorizationTextField.width)
            maker.height.equalTo(LoginScreenSizes.AuthorizationTextField.height)
        }
    }
    
    private func setLoginButtonConstraints() {
        loginButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(passwordTextField.snp.bottom).offset(LoginScreenSizes.AuthorizationButton.topOffset)
            maker.width.equalTo(LoginScreenSizes.AuthorizationButton.width)
            maker.height.equalTo(LoginScreenSizes.AuthorizationButton.height)
        }
    }
}
