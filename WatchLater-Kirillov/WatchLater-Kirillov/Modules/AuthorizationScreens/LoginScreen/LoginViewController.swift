//
//  LoginViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginViewControllerProtocol: AnyObject {

    func loginFailedStatee(displayMessage: String)
    func presentThumbnailsViewController()
}

class LoginViewController: BaseViewController, UITextFieldDelegate, LoginViewControllerProtocol {
    
    private lazy var watchLaterLogoImageView = makeWatchLaterLogoImageView()
    private lazy var emailTextField = makeTextField(type: .email)
    private lazy var passwordTextField = makeTextField(type: .password)
    private lazy var loginButton = makeLoginButton()
    private lazy var registrationButton = makeRegistrationButton()
    private lazy var loginFailedLabel = makeLoginFailedLabel()
    
    private var isFieldsSet: Bool {
        return emailTextField.text != nil
            && !emailTextField.text!.isEmpty
            && passwordTextField.text != nil
            && !passwordTextField.text!.isEmpty
    }
    
    private var isLoginFaieldSateActive = false
    
    private var interactor: LoginInteractorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        addSubviews()
        loginFailedLabel.isHidden = true
        setGestures()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupComponents(interactor: LoginInteractorProtocol) {
        self.interactor = interactor
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func loginFailedStatee(displayMessage: String) {
        showLoginFailedState(displayMessage: displayMessage)
    }
    
    func presentThumbnailsViewController() {
        print("SUCCESS")
        RegistrationRouter.removeViewController()
        LoginRouter.removeViewController()
        UIWindowService.replaceWindowWithNewOne(rootViewController: FavouriteThumbnailsViewController())
    }
    
    private func addSubviews() {
        view.addSubview(watchLaterLogoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        view.addSubview(loginFailedLabel)
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(hideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    private func getLoginData() -> LoginData? {
        guard isFieldsSet
        else {
            return nil
        }
        return LoginData(email: emailTextField.text!,
                         password: passwordTextField.text!)
    }
    
    private func showLoginFailedState(displayMessage: String) {
        isLoginFaieldSateActive = true
        loginFailedLabel.isHidden = false
        loginFailedLabel.text = displayMessage
        emailTextField.textColor = Asset.Colors.loginFailedText.color
        passwordTextField.textColor = Asset.Colors.loginFailedText.color
    }
    
    private func showNormalState() {
        isLoginFaieldSateActive = false
        loginFailedLabel.isHidden = true
        emailTextField.textColor = Asset.Colors.loginTextColor.color
        passwordTextField.textColor = Asset.Colors.loginTextColor.color
    }
    
    private func handleTextFieldsActivity(active: AuthorizationTextField,
                                          nextToBeField: AuthorizationTextField) {
        _ = active.resignFirstResponder()
        if let loginData = getLoginData() {
            interactor.login(data: loginData)
            print(loginData)
        } else if active.text != nil
                    && !active.text!.isEmpty {
            nextToBeField.becomeFirstResponder()
        }
    }
    
    private func getActiveTextField() -> AuthorizationTextField? {
        if emailTextField.isEditing {
            return emailTextField
        } else if passwordTextField.isEditing {
            return passwordTextField
        }
        return nil
    }
    
    @objc private func hideKeyboard() {
        guard let textField = getActiveTextField() else {
            return
        }
        _ = textField.resignFirstResponder()
    }
    
    @objc private func emailTextFieldDonePressed() {
        handleTextFieldsActivity(active: emailTextField,
                                 nextToBeField: passwordTextField)
    }
    
    @objc private func passwordTextFieldDonePressed() {
        handleTextFieldsActivity(active: passwordTextField,
                                 nextToBeField: emailTextField)
    }
    
    @objc private func loginButtonTaped() {
        hideKeyboard()
        if let loginData = getLoginData() {
            interactor.login(data: loginData)
            print(loginData)
        }
    }
    
    @objc private func textFieldDidChange() {
        if isLoginFaieldSateActive {
            showNormalState()
        }
        if isFieldsSet
            && !loginButton.isEnabled {
            loginButton.isEnabled = true
        } else if !isFieldsSet
                    && loginButton.isEnabled {
            loginButton.isEnabled = false
        }
    }
    
    @objc private func openRegistrationViewController() {
        RegistrationRouter.presentRegistrationViewController(navigationController: navigationController!)
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
        let inset = UIEdgeInsets(
                top: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                left: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset,
                bottom: LoginScreenSizes.AuthorizationTextField.textRectangleTopOffset,
                right: LoginScreenSizes.AuthorizationTextField.textRectangleSideOffset
            )
        let textField = AuthorizationTextField(type: type,
                                               inset: inset)
        textField.delegate = self
        textField.addTarget(
                    self,
                    action: #selector(textFieldDidChange),
                    for: .editingChanged
                )
        switch type {
        case .email:
            textField.addTarget(
                        self,
                        action: #selector(emailTextFieldDonePressed),
                        for: .editingDidEndOnExit
                    )
        
        case .password:
            textField.addTarget(
                        self,
                        action: #selector(passwordTextFieldDonePressed),
                        for: .editingDidEndOnExit
                    )

        default:
            break
        }
        return textField
    }
    
    private func makeLoginButton() -> AuthorizationButton {
        let colorSet = AuthorizationButton.ColorSet(
                                enabledText: Asset.Colors.enabledAuthorizationButtonText.color,
                                enabledBackground: .clear,
                                enabledBorder: Asset.Colors.enabledAuthorizationButtonBorderLine.color,
                                disabledText: Asset.Colors.disabledAuthorizationButtonText.color,
                                disabledBackground: Asset.Colors.disabledAuthorizationButtonBackground.color,
                                disabledBorder: .clear)
        let button = AuthorizationButton(colorSet: colorSet,
                                         text: Text.Common.login,
                                         fontSize: LoginScreenSizes.AuthorizationButton.fontSize)
        button.addTarget(self,
                         action: #selector(loginButtonTaped),
                         for: .touchUpInside)
        return button
    }
    
    private func makeRegistrationButton() -> UIButton {
        let buttonText = Text.Authorization.registrationQuestion + " " + Text.Authorization.registration
        let questionRange = (buttonText as NSString).range(of: Text.Authorization.registrationQuestion)
        let registrationRange = (buttonText as NSString).range(of: Text.Authorization.registration)

        let mutableButtonText = NSMutableAttributedString(string: buttonText)
        mutableButtonText.addAttribute(
                            .foregroundColor,
                            value: Asset.Colors.registrationQuestionLabelText.color,
                            range: questionRange
                        )
        mutableButtonText.addAttribute(
                            .foregroundColor,
                            value: Asset.Colors.enabledAuthorizationButtonText.color,
                            range: registrationRange
                        )
        
        let mutableButtonTextHighlited = NSMutableAttributedString(string: buttonText)
        mutableButtonTextHighlited.addAttribute(
                                        .foregroundColor,
                                        value: Asset.Colors.registrationQuestionLabelText.color,
                                        range: questionRange
                                    )
        mutableButtonTextHighlited.addAttribute(
                        .foregroundColor,
                        value: Asset.Colors.enabledAuthorizationButtonText.color.withAlphaComponent(0.6),
                        range: registrationRange
                    )

        let button = UIButton()
        button.setAttributedTitle(mutableButtonText,
                                  for: .normal)
        button.setAttributedTitle(mutableButtonTextHighlited,
                                  for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: LoginScreenSizes.RegistrationButton.fontSize)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self,
                         action: #selector(openRegistrationViewController),
                         for: .touchUpInside)
        return button
    }
    
    private func makeLoginFailedLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.Authorization.failed
        label.textColor = Asset.Colors.loginFailedText.color
        label.font = UIFont.systemFont(ofSize: LoginScreenSizes.LoginFailedLabel.fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }
}

// MARK: Constraints
extension LoginViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldConstraints()
        setLoginButtonConstraints()
        setRegistrationButtonConstraints()
        setLoginFailedLabelConstraints()
    }
    
    private func setWatchLaterLogoConstraints() {
        watchLaterLogoImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(LoginScreenSizes.WatchLaterLogo.topOffset)
            maker.width.equalToSuperview().multipliedBy(LoginScreenSizes.WatchLaterLogo.ratioWithScreenWidth)
            maker.height.equalTo(watchLaterLogoImageView.snp.width).multipliedBy(LoginScreenSizes.WatchLaterLogo.ratioHeightWithWidth)
        }
    }
    
    private func setEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(watchLaterLogoImageView).inset(LoginScreenSizes.AuthorizationTextField.topOffset)
            maker.width.equalToSuperview()
            maker.height.equalTo(LoginScreenSizes.AuthorizationTextField.height)
        }
    }
    
    private func setPasswordTextFieldConstraints() {
        passwordTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(emailTextField.snp.bottom)
            maker.width.equalToSuperview()
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
    
    private func setRegistrationButtonConstraints() {
        registrationButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(loginButton.snp.bottom).offset(LoginScreenSizes.RegistrationButton.topOffset)
            maker.width.equalToSuperview().multipliedBy(LoginScreenSizes.RegistrationButton.ratioWithScreenWidth)
            maker.height.equalTo(LoginScreenSizes.RegistrationButton.height)
        }
    }
    
    private func setLoginFailedLabelConstraints() {
        loginFailedLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(passwordTextField.snp.bottom).offset(LoginScreenSizes.LoginFailedLabel.topOffset)
            maker.width.equalToSuperview().multipliedBy(LoginScreenSizes.LoginFailedLabel.ratioWithScreenWidth)
            maker.height.equalTo(LoginScreenSizes.LoginFailedLabel.height)
        }
    }
}
