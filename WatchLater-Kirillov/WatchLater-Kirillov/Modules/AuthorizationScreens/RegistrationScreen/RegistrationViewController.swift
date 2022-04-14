//
//  RegistrationViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/14/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class RegistrationViewController: BaseViewController, UITextFieldDelegate {
    
    private lazy var logoImageView = makeLogoImageView()
    private lazy var emailTextField = makeTextField(type: .email)
    private lazy var passwordTextField = makeTextField(type: .password)
    private lazy var repeatPasswordTextField = makeTextField(type: .repeatPassword)
    
    private var isFieldsSet: Bool {
        return emailTextField.text != nil
            && !emailTextField.text!.isEmpty
            && passwordTextField.text != nil
            && !passwordTextField.text!.isEmpty
            && repeatPasswordTextField.text != nil
            && !repeatPasswordTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
                                                                            title: "",
                                                                            style: .plain,
                                                                            target: self,
                                                                            action: nil)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(repeatPasswordTextField)
        setGestures()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // TODO: - must be validate for cmp passwords
    private func getAuthorizatioinData() -> LoginData? {
        guard isFieldsSet
        else {
            return nil
        }
        return LoginData(password: passwordTextField.text!, email: emailTextField.text!)
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    @objc private func hideKeyboard() {
        if emailTextField.isEditing {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isEditing {
            passwordTextField.resignFirstResponder()
        } else if repeatPasswordTextField.isEditing {
            repeatPasswordTextField.resignFirstResponder()
        }
    }
    
    @objc private func emailTextFieldDonePressed() {
        emailTextField.resignFirstResponder()
        if let loginData = getAuthorizatioinData() {
            // TODO: - Do request
            print(loginData)
        } else if emailTextField.text != nil
                    && !emailTextField.text!.isEmpty {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    @objc private func passwordTextFieldDonePressed() {
        passwordTextField.resignFirstResponder()
        if let loginData = getAuthorizatioinData() {
            // TODO: - Do request
            print(loginData)
        } else if passwordTextField.text != nil
                    && !passwordTextField.text!.isEmpty {
            repeatPasswordTextField.becomeFirstResponder()
        }
    }
    
    @objc private func repeatPasswordTextFieldDonePressed() {
        repeatPasswordTextField.resignFirstResponder()
        if let loginData = getAuthorizatioinData() {
            // TODO: - Do request
            print(loginData)
        } else if repeatPasswordTextField.text != nil
                    && !repeatPasswordTextField.text!.isEmpty {
            emailTextField.becomeFirstResponder()
        }
    }
}

extension RegistrationViewController {
    
    private func makeLogoImageView() -> UIImageView {
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
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        switch type {
        case .email:
            textField.addTarget(self, action: #selector(emailTextFieldDonePressed), for: .editingDidEndOnExit)
        
        case .password:
            textField.addTarget(self, action: #selector(passwordTextFieldDonePressed), for: .editingDidEndOnExit)

        case .repeatPassword:
            textField.addTarget(self, action: #selector(repeatPasswordTextFieldDonePressed), for: .editingDidEndOnExit)
        }
        return textField
    }
}

extension RegistrationViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldConstraints()
        setRepeatPasswordTextFieldConstraints()
    }
    
    private func setWatchLaterLogoConstraints() {
        logoImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(RegistrationScreenSizes.Logo.topOffset)
            maker.width.equalTo(RegistrationScreenSizes.Logo.width)
            maker.height.equalTo(RegistrationScreenSizes.Logo.height)
        }
    }
    
    private func setEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(logoImageView).inset(RegistrationScreenSizes.AuthorizationTextField.topOffset)
            maker.width.equalTo(RegistrationScreenSizes.AuthorizationTextField.width)
            maker.height.equalTo(RegistrationScreenSizes.AuthorizationTextField.height)
        }
    }
    
    private func setPasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(emailTextField.snp.bottom)
            maker.width.equalTo(RegistrationScreenSizes.AuthorizationTextField.width)
            maker.height.equalTo(RegistrationScreenSizes.AuthorizationTextField.height)
        }
    }
    
    private func setRepeatPasswordTextFieldConstraints() {
        repeatPasswordTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(passwordTextField.snp.bottom)
            maker.width.equalTo(RegistrationScreenSizes.AuthorizationTextField.width)
            maker.height.equalTo(RegistrationScreenSizes.AuthorizationTextField.height)
        }
    }
}
