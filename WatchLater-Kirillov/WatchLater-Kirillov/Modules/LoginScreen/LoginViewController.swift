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
    private lazy var emailTextField = makeTextField(
                                            placeholderString: Text.Authorization.Placeholder.email,
                                            viewMode: .whileEditing,
                                            keyboardType: .emailAddress,
                                            isPassword: false)
    
    private lazy var passwordTextField = makeTextField(
                                            placeholderString: Text.Authorization.Placeholder.password,
                                            viewMode: .never,
                                            keyboardType: .default,
                                            isPassword: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(watchLaterLogoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        setGestures()
        setConstraints()
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    @objc private func hideKeyboard(_ guestureRecognizer: UIGestureRecognizer) {
        if emailTextField.isEditing {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isEditing {
            passwordTextField.resignFirstResponder()
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
    
    private func makeTextField(placeholderString: String, viewMode: UITextField.ViewMode, keyboardType: UIKeyboardType, isPassword: Bool) -> AuthorizationTextField {
        let inset = UIEdgeInsets(top: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                                 left: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset,
                                 bottom: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                                 right: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset)
        let textField = AuthorizationTextField(inset: inset)
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
        textField.addBottomBoarder(color: Asset.Colors.textFieldBoarderColor.color,
                                   height: LoginScreenSizes.AuthorizationTextField.bottomBoarderLineHeight,
                                   sideOffset: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset)
//        textField.textInputView.backgroundColor = .green
//        textField.backgroundColor = .red
        return textField
    }
}

// MARK: Constraints
extension LoginViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldConstraints()
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
}
