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
}

final class LoginViewController: UIViewController {
    
    enum ViewState {
        case biometry, keyboardInput
    }
    
    private var viewState: ViewState = .biometry
    private var isBiometryAvalilable = true
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    private lazy var loginWithBiometryButton = makeLoginWithBiometryButton()
    
    private var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBiometryAvalilable = true
            viewState = .biometry
        } else {
            isBiometryAvalilable = false
            viewState = .keyboardInput
        }
        makeActive(view: viewState)
    }
    
    func setupComponents(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
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
        view.addSubview(loginWithBiometryButton)
    }
    
    private func makeActive(view: ViewState) {
        switch view {
        case .biometry:
            keyboard.isHidden = true
            passwordStackView.isHidden = true
            loginWithBiometryButton.isHidden = false
            
        case .keyboardInput:
            keyboard.isHidden = false
            passwordStackView.isHidden = false
            loginWithBiometryButton.isHidden = true
        }
    }
    
    private func proceedFilledPassword() {
    }
    
    private func getBiometryType() -> BiometryType {
        let authContext = LAContext()
        var error: NSError?
       _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
       switch authContext.biometryType {
       case .none:
           return .none

       case .touchID:
           return .touchID

       case .faceID:
           return .faceID

       @unknown default:
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
    
    @objc private func biometryLogin() {
    }
}

extension LoginViewController: KeyboardDelegate {
    
    func handleKeyboardTap(key: KeyboardView.KeyType) {
        switch key {
        case .number(let number):
            fillPasswordDependsOnViewState(number: number)
            
        case .delete:
            presenter.deleteLastNumber()
        }
    }
    
    private func fillPasswordDependsOnViewState(number: Int) {
    }
}

extension LoginViewController: BiometryDelegate {
    
    func handleBiometry() {
        switch getBiometryType() {
        case .none:
            let popup = Popup(title: Text.Common.error, description: Text.Descriptions.biometryUnavalable)
            popup.addButton(title: Text.Common.confirm, type: .custom, action: nil)
            popup.alpha = 0
            showPopup(popup: popup)
            
        default:
            print("Show Biometry view")
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
                proceedFilledPassword()
            }
        }
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
    
    private func makeInputPasswordLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        return label
    }
    
    private func makeSaveButton() -> CustomButton {
        let button = CustomButton()
        button.setTitle(Text.Common.backward, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.setTitleColor(Asset.textColor.color, for: .normal)
        return button
    }
    
    private func makeLoginWithBiometryButton() -> CustomButton {
        let button = CustomButton()
        switch getBiometryType() {
        case .faceID:
            button.setImage(UIImage(systemName: SFSymbols.faceId), for: .normal)
            
        default:
            button.setImage(UIImage(systemName: SFSymbols.touchId), for: .normal)
        }
        button.tintColor = Asset.textColor.color
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(biometryLogin), for: .touchUpInside)
        return button
    }
}

// MARK: Constraints

extension LoginViewController {
    
    private func setConstraints() {
        setKeyboardConstraints()
        setPasswordStackConstraints()
        setLoginWithBiometryButtonConstraints()
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
    
    private func setLoginWithBiometryButtonConstraints() {
        loginWithBiometryButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(LoginSizes.BiometryButtonLogin.centerYOffset)
            maker.width.equalTo(LoginSizes.BiometryButtonLogin.width)
            maker.height.equalTo(LoginSizes.BiometryButtonLogin.height)
        }
    }
    
    private func setPopupConstraints(view: UIView) {
        view.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
