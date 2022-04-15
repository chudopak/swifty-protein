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
    private lazy var registrationFailedLabel = makeRegistrationFailedLabel()
    private lazy var registerButton = makeRegisterButton()
    private lazy var spinner = makeSpinner()
    
    private var isRegistrationFaieldSateActive = false
    
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
        view.addSubview(registrationFailedLabel)
        view.addSubview(registerButton)
        view.addSubview(spinner)
        registrationFailedLabel.isHidden = true
        spinner.isHidden = true
        setGestures()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func getAuthorizatioinData() -> RegistrationData? {
        guard isFieldsSet
        else {
            return nil
        }
        return RegistrationData(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func isPasswordsMatch() -> Bool {
        if isFieldsSet && passwordTextField.text! == repeatPasswordTextField.text! {
            return true
        }
        return false
    }
    
    private func validateRegistrationDataForRequest() {
        if isPasswordsMatch(),
           let loginData = getAuthorizatioinData() {
            processRegistration()
            print(loginData)
        } else {
            showRegistrationFailedState(message: Text.Authorization.passwordsNotMatch)
        }
    }
    
    private func processRegistration() {
        // TODO: - Do request
        registerButton.isHidden = true
        spinner.startAnimating()
        spinner.isHidden = false
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) { [weak self] in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.registerButton.isHidden = false
            }
        }
    }
    
    private func showRegistrationFailedState(message: String) {
        isRegistrationFaieldSateActive = true
        registrationFailedLabel.isHidden = false
        registrationFailedLabel.text = message
        emailTextField.textColor = Asset.Colors.loginFailedText.color
        passwordTextField.textColor = Asset.Colors.loginFailedText.color
        repeatPasswordTextField.textColor = Asset.Colors.loginFailedText.color
    }
    
    private func showNormalState() {
        isRegistrationFaieldSateActive = false
        registrationFailedLabel.isHidden = true
        emailTextField.textColor = Asset.Colors.loginTextColor.color
        passwordTextField.textColor = Asset.Colors.loginTextColor.color
        repeatPasswordTextField.textColor = Asset.Colors.loginTextColor.color
    }

    private func handleTextFieldsActivity(active: AuthorizationTextField,
                                          nextToBeField: AuthorizationTextField) {
        active.resignFirstResponder()
        if isFieldsSet {
            validateRegistrationDataForRequest()
        } else if active.text != nil
                    && !active.text!.isEmpty {
            nextToBeField.becomeFirstResponder()
        }
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
        handleTextFieldsActivity(active: emailTextField,
                                 nextToBeField: passwordTextField)
    }
    
    @objc private func passwordTextFieldDonePressed() {
        handleTextFieldsActivity(active: passwordTextField,
                                 nextToBeField: repeatPasswordTextField)
    }
    
    @objc private func repeatPasswordTextFieldDonePressed() {
        handleTextFieldsActivity(active: repeatPasswordTextField,
                                 nextToBeField: emailTextField)
    }
    
    @objc private func textFieldDidChange() {
        if isRegistrationFaieldSateActive {
            showNormalState()
        }
        if isFieldsSet && !registerButton.isEnabled {
            registerButton.isEnabled = true
        } else if !isFieldsSet && registerButton.isEnabled {
            registerButton.isEnabled = false
        }
    }
    
    @objc private func registerButtonTapped() {
        hideKeyboard()
        validateRegistrationDataForRequest()
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
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
    
    private func makeRegistrationFailedLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Asset.Colors.loginFailedText.color
        label.font = UIFont.systemFont(ofSize: RegistrationScreenSizes.RegistrationFailedLabel.fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }
    
    private func makeRegisterButton() -> AuthorizationButton {
        let colorSet = AuthorizationButton.ColorSet(
                                    enabledText: Asset.Colors.enabledAuthorizationButtonText.color,
                                    enabledBackground: .clear,
                                    enabledBorder: Asset.Colors.enabledAuthorizationButtonBorderLine.color,
                                    disabledText: Asset.Colors.disabledAuthorizationButtonText.color,
                                    disabledBackground: Asset.Colors.disabledAuthorizationButtonBackground.color,
                                    disabledBorder: .clear)
        let button = AuthorizationButton(colorSet: colorSet, text: Text.Authorization.registration)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = .black
        return spinner
    }
}

extension RegistrationViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldConstraints()
        setRepeatPasswordTextFieldConstraints()
        setLoginFailedLabelConstraints()
        setLoginButtonConstraints()
        setSpinnerConstratints()
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
    
    private func setLoginFailedLabelConstraints() {
        registrationFailedLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(repeatPasswordTextField.snp.bottom).offset(RegistrationScreenSizes.RegistrationFailedLabel.topOffset)
            maker.width.equalTo(RegistrationScreenSizes.RegistrationFailedLabel.width)
            maker.height.equalTo(RegistrationScreenSizes.RegistrationFailedLabel.height)
        }
    }
    
    private func setLoginButtonConstraints() {
        registerButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(repeatPasswordTextField.snp.bottom).offset(RegistrationScreenSizes.RegisterButton.topOffset)
            maker.width.equalTo(RegistrationScreenSizes.RegisterButton.width)
            maker.height.equalTo(RegistrationScreenSizes.RegisterButton.height)
        }
    }
    
    private func setSpinnerConstratints() {
        spinner.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(repeatPasswordTextField.snp.bottom).offset(RegistrationScreenSizes.Spinner.topOffset)
            maker.width.equalTo(RegistrationScreenSizes.Spinner.width)
            maker.height.equalTo(RegistrationScreenSizes.Spinner.height)
        }
    }
}
