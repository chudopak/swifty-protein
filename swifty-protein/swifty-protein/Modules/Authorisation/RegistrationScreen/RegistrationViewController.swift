//
//  RegistrationViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/6/22.
//

import UIKit

protocol RegistrationViewControllerProtocol: AnyObject {
    func changePasswordLabelState(index: Int, isFilled: Bool)
    func presentRepeatPasswordView()
}

final class RegistrationViewController: UIViewController {
    
    enum ViewState {
        case firstLaunch, repeatPassword
    }
    
    private var viewState: ViewState = .firstLaunch
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    private lazy var inputPasswordLabel = makeInputPasswordLabel()
    private lazy var backwardButton = makeSaveButton()
    
    private var presenter: RegistrationPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    func setupComponents(presenter: RegistrationPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setView() {
        view.backgroundColor = Asset.primaryBackground.color
        view.addSubview(keyboard)
        passwordLabels.reserveCapacity(RegistrationSizes.passwordLength)
        for _ in 0..<RegistrationSizes.passwordLength {
            let label = makePasswordLabel()
            passwordLabels.append(label)
            setPasswordNumberLabelConstraints(label: label)
        }
        view.addSubview(passwordStackView)
        view.addSubview(inputPasswordLabel)
        view.addSubview(backwardButton)
        backwardButton.isHidden = true
    }
    
    private func proceedFilledPassword() {
        switch viewState {
        case .firstLaunch:
            viewState = .repeatPassword
            backwardButton.isHidden = false
            inputPasswordLabel.text = Text.Common.repeatPassword
            clearPasswordLabels()
            shakeInputPasswordLabel()
            
        case .repeatPassword:
            print("repeatPassword")
        }
    }
    
    private func clearPasswordLabels() {
        for view in passwordLabels {
            view.backgroundColor = .clear
        }
        view.layoutIfNeeded()
    }
    
    private func shakeInputPasswordLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(
            cgPoint: CGPoint(
                x: inputPasswordLabel.center.x - RegistrationSizes.InputPasswordLabel.shakeOffset,
                y: inputPasswordLabel.center.y
            )
        )
        animation.toValue = NSValue(
            cgPoint: CGPoint(
                x: inputPasswordLabel.center.x + RegistrationSizes.InputPasswordLabel.shakeOffset,
                y: inputPasswordLabel.center.y
            )
        )
        inputPasswordLabel.layer.add(animation, forKey: "position")
    }
}

extension RegistrationViewController: RegistrationViewControllerProtocol {
    
    func changePasswordLabelState(index: Int, isFilled: Bool) {
        if index >= 0 && index < passwordLabels.count {
            passwordLabels[index].backgroundColor = isFilled
                                                        ? Asset.textColor.color
                                                        : .clear
            passwordLabels[index].layoutIfNeeded()
        }
    }
    
    func presentRepeatPasswordView() {
        proceedFilledPassword()
    }
}

extension RegistrationViewController: KeyboardDelegate {
    
    func handleKeyboardTap(key: KeyboardView.KeyType) {
        switch key {
        case .number(let number):
            fillPasswordDependsOnViewState(number: number)
            
        case .delete:
            deletePasswordNumberDependsOnViewState()
        }
    }
    
    private func fillPasswordDependsOnViewState(number: Int) {
        switch viewState {
        case .firstLaunch:
            presenter.handleNewPasswordNumber(number: number)

        case .repeatPassword:
            presenter.handleNewRepeatedPasswordNumber(number: number)
        }
    }
    
    private func deletePasswordNumberDependsOnViewState() {
        switch viewState {
        case .firstLaunch:
            presenter.deletePasswordLastNumber()

        case .repeatPassword:
            presenter.deleteRepeatPasswordLastNumber()
        }
    }
}

extension RegistrationViewController {
    
    private func makeKeyboardView() -> KeyboardView {
        let view = KeyboardView(delegate: self)
        return view
    }
    
    private func makePasswordLabel() -> UILabel {
        let field = UILabel()
        field.clipsToBounds = true
        field.layer.borderWidth = RegistrationSizes.PasswordDotLabel.boarderWidth
        field.layer.borderColor = Asset.textColor.color.cgColor
        field.layer.cornerRadius = RegistrationSizes.PasswordDotLabel.cornerRadius
        return field
    }
    
    private func makeStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        for item in views {
            stackView.addArrangedSubview(item)
        }
        stackView.axis = .horizontal
        stackView.spacing = RegistrationSizes.PasswordStack.spacing
        return stackView
    }
    
    private func makeInputPasswordLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        label.text = Text.Common.createPassword
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

extension RegistrationViewController {
    
    private func setConstraints() {
        setKeyboardConstraints()
        setPasswordStackConstraints()
        setInputPasswordLabelConstraints()
        setBackwardButtonConstraints()
    }
    
    private func setPasswordNumberLabelConstraints(label: UILabel) {
        label.snp.makeConstraints { maker in
            maker.width.equalTo(RegistrationSizes.PasswordDotLabel.width)
            maker.height.equalTo(RegistrationSizes.PasswordDotLabel.height)
        }
    }
    
    private func setPasswordStackConstraints() {
        passwordStackView.snp.makeConstraints { maker in
            maker.width.equalTo(RegistrationSizes.PasswordStack.width)
            maker.height.equalTo(RegistrationSizes.PasswordStack.height)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(keyboard.snp.top).offset(-RegistrationSizes.PasswordStack.bottom)
        }
    }
    
    private func setKeyboardConstraints() {
        keyboard.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(RegistrationSizes.KeyboardView.centerYOffset)
            maker.width.equalTo(RegistrationSizes.KeyboardView.width)
            maker.height.equalTo(RegistrationSizes.KeyboardView.height)
        }
    }
    
    private func setInputPasswordLabelConstraints() {
        inputPasswordLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.height.equalTo(RegistrationSizes.InputPasswordLabel.height)
            maker.bottom.equalTo(passwordStackView.snp.top).offset(-RegistrationSizes.InputPasswordLabel.bottomOffset)
        }
    }
    
    private func setBackwardButtonConstraints() {
        backwardButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(RegistrationSizes.SavePasswordButton.width)
            maker.height.equalTo(RegistrationSizes.SavePasswordButton.height)
            maker.top.equalTo(keyboard.snp.bottom).offset(RegistrationSizes.SavePasswordButton.topOffset)
        }
    }
}
