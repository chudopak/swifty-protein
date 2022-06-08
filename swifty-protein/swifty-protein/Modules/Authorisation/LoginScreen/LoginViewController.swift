//
//  LoginViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit
import LocalAuthentication

protocol LoginViewControllerProtocol: AnyObject {
    func changePasswordLabelState(index: Int, isFilled: Bool)
    func presentProteinListScreen()
    func showFailedToLoginPopup(description: String)
}

final class LoginViewController: UIViewController {
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    private lazy var inputPasswordLabel = makeLabel(text: Text.Common.inputPassword)
    private lazy var restorePasswordButton = makeRestorePasswordButton()
    
    private var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationController()
        clearPasswordLabels()
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            loginWithBiometry()
        }
    }
    
    func setupComponents(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setView() {
        view.backgroundColor = Asset.primaryBackground.color
        view.addSubview(keyboard)
        passwordLabels.reserveCapacity(LoginSizes.passwordLength)
        for _ in 0..<LoginSizes.passwordLength {
            let label = makePasswordLabel()
            passwordLabels.append(label)
            setPasswordNumberLabelConstraints(label: label)
        }
        view.addSubview(passwordStackView)
        view.addSubview(inputPasswordLabel)
        view.addSubview(restorePasswordButton)
    }
    
    private func getBiometryType() -> BiometryType {
        let authContext = LAContext()
        var error: NSError?
       _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
       switch authContext.biometryType {
       case .touchID:
           return .touchID

       case .faceID:
           return .faceID

       default:
           return .none
       }
    }
    
    private func showPopup(popup: Popup) {
        view.addSubview(popup)
        setPopupConstraints(view: popup)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                popup.alpha = 1
            },
            completion: { completion in
                if completion {
                    popup.showPopup()
                }
            }
        )
    }
    
    private func showErrorPopup(description: String) {
        let popup = Popup(title: Text.Common.error, description: description)
        popup.addButton(title: Text.Common.confirm, type: .custom, action: nil)
        popup.alpha = 0
        showPopup(popup: popup)
    }
    
    private func loginWithBiometry() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = Text.Descriptions.loginWithTouchID
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { succes, error in
                DispatchQueue.main.async { [weak self] in
                    if succes {
                        self?.presentProteinListScreen()
                    } else {
                        if let error = error {
                            print(error)
                        }
                    }
                }
            }
        } else {
            showErrorPopup(description: Text.Descriptions.biometryUnavalable)
        }
    }
    
    private func clearPasswordLabels() {
        for view in passwordLabels {
            view.backgroundColor = .clear
        }
        view.layoutIfNeeded()
    }
    
    @objc private func restorePassword() {
        let restorePasswordVC = RestorePasswordConfigurator().setupModule()
        navigationController?.pushViewController(restorePasswordVC, animated: true)
    }
}

extension LoginViewController: KeyboardDelegate {
    
    func handleKeyboardTap(key: KeyboardView.KeyType) {
        switch key {
        case .number(let number):
            presenter.handleNewPasswordNumber(number: number)
            
        case .delete:
            presenter.deleteLastNumber()
        }
    }
}

extension LoginViewController: BiometryDelegate {
    
    func handleBiometry() {
        switch getBiometryType() {
        case .none:
            showErrorPopup(description: Text.Descriptions.biometryUnavalable)
            
        default:
            loginWithBiometry()
        }
    }
}

extension LoginViewController: LoginViewControllerProtocol {
    
    func changePasswordLabelState(index: Int, isFilled: Bool) {
        if index >= 0 && index < passwordLabels.count {
            passwordLabels[index].backgroundColor = isFilled
                                                        ? Asset.textColor.color
                                                        : .clear
            passwordLabels[index].layoutIfNeeded()
            if index + 1 == passwordLabels.count {
                presenter.tryLogin()
            }
        }
    }
    
    func presentProteinListScreen() {
        if WindowService.isMainScreenExist {
            WindowService.presentProteinListNavigationController()
        } else {
            let proteinListVC = ProteinListConfigurator().setupModule()
            let navigationController = UINavigationController(rootViewController: proteinListVC)
            WindowService.replaceRootViewController(with: navigationController)
            WindowService.setProteinListNavigationController(vc: navigationController)
        }
    }
    
    func showFailedToLoginPopup(description: String) {
        clearPasswordLabels()
        showErrorPopup(description: description)
    }
}

// MARK: Creating UI elements

extension LoginViewController {
    
    private func makeKeyboardView() -> KeyboardView {
        let view = KeyboardView(delegate: self)
        view.biometryDelegate = self
        return view
    }
    
    private func makePasswordLabel() -> UILabel {
        let field = UILabel()
        field.clipsToBounds = true
        field.layer.borderWidth = LoginSizes.PasswordDotLabel.boarderWidth
        field.layer.borderColor = Asset.textColor.color.cgColor
        field.layer.cornerRadius = LoginSizes.PasswordDotLabel.cornerRadius
        return field
    }
    
    private func makeStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        for item in views {
            stackView.addArrangedSubview(item)
        }
        stackView.axis = .horizontal
        stackView.spacing = LoginSizes.PasswordStack.spacing
        return stackView
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        label.text = text
        return label
    }
    
    private func makeRestorePasswordButton() -> CustomButton {
        let button = CustomButton()
        button.setTitle(Text.Common.restorePassword, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: LoginSizes.RestorePasswordButton.fontSize)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.setTitleColor(Asset.buttonsColor.color, for: .normal)
        button.addTarget(self, action: #selector(restorePassword), for: .touchUpInside)
        return button
    }
}

// MARK: Constraints

extension LoginViewController {
    
    private func setConstraints() {
        setKeyboardConstraints()
        setPasswordStackConstraints()
        setInputPasswordLabelConstraints()
        setRestorePasswordButtonConstraints()
    }
    
    private func setPasswordNumberLabelConstraints(label: UILabel) {
        label.snp.makeConstraints { maker in
            maker.width.equalTo(LoginSizes.PasswordDotLabel.width)
            maker.height.equalTo(LoginSizes.PasswordDotLabel.height)
        }
    }
    
    private func setPasswordStackConstraints() {
        passwordStackView.snp.makeConstraints { maker in
            maker.width.equalTo(LoginSizes.PasswordStack.width)
            maker.height.equalTo(LoginSizes.PasswordStack.height)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(keyboard.snp.top).offset(-LoginSizes.PasswordStack.bottom)
        }
    }
    
    private func setKeyboardConstraints() {
        keyboard.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(LoginSizes.KeyboardView.centerYOffset)
            maker.width.equalTo(LoginSizes.KeyboardView.width)
            maker.height.equalTo(LoginSizes.KeyboardView.height)
        }
    }
    
    private func setPopupConstraints(view: UIView) {
        view.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setInputPasswordLabelConstraints() {
        inputPasswordLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.height.equalTo(LoginSizes.InputPasswordLabel.height)
            maker.bottom.equalTo(passwordStackView.snp.top).offset(-LoginSizes.InputPasswordLabel.bottomOffset)
        }
    }
    
    private func setRestorePasswordButtonConstraints() {
        restorePasswordButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(LoginSizes.RestorePasswordButton.width)
            maker.height.equalTo(LoginSizes.RestorePasswordButton.height)
            maker.top.equalTo(keyboard.snp.bottom).offset(LoginSizes.RestorePasswordButton.topOffset)
        }
    }
}
