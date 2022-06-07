//
//  LoginViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

protocol KeyboardDelegate: AnyObject {
    func handleKeyboardTap(key: KeyboardView.KeyType)
}

protocol LoginViewControllerProtocol: AnyObject {
    func changePasswordLabelState(index: Int, isFilled: Bool)
}

final class LoginViewController: UIViewController {
    
    enum ViewState {
        case biometry, keyboardInput
    }
    
    private var viewState: ViewState = .biometry
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    
    private var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WE ARE IN LOGIN")
        setView()
        setConstraints()
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
    }
    
    private func makeActive(view: ViewState) {
        switch view {
        case .biometry:
            break
            
        case .keyboardInput:
            break
        }
    }
    
    private func proceedFilledPassword() {
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
}

// MARK: Constraints

extension LoginViewController {
    
    private func setConstraints() {
        setKeyboardConstraints()
        setPasswordStackConstraints()
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
}
