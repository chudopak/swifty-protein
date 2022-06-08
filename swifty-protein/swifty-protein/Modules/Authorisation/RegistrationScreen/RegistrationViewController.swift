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
    func presentRestorePasswordQuestion()
    func passwordsDoesnotMatch()
    func presentAnswerError(description: String)
    func presentConfirmPopup(description: String)
    func completeRegistration(isDataSeaved: Bool)
}

final class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    private enum ViewState {
        case firstLaunch, repeatPassword, passwordsNotEqual, question
    }
    
    private var viewState: ViewState = .firstLaunch
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    private lazy var inputPasswordLabel = makeLabel(text: Text.Common.createPassword)
    private lazy var backwardButton = makeBackwardButton()
    
    private lazy var answerTextField = makeAnswerTextField()
    private lazy var saveRegistrationDataButton = makeSaveRegistrationData()
    private lazy var questionLabel = makeLabel(text: Text.Questions.whereWereYouBorn)
    private lazy var questionStackView = makeQuestionStackView(
        views: [
            questionLabel,
            answerTextField,
            saveRegistrationDataButton
        ]
    )
    
    private var presenter: RegistrationPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setGestures()
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
        view.addSubview(questionStackView)
        questionStackView.isHidden = true
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(textFieldHideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    private func proceedFilledPassword() {
        switch viewState {
        case .firstLaunch:
            viewState = .repeatPassword
            changeInputPasswordLabelDependsOnState()
            backwardButton.isHidden = false
            clearPasswordLabels()
            
        case .repeatPassword:
            viewState = .question
            keyboard.isHidden = true
            passwordStackView.isHidden = true
            inputPasswordLabel.isHidden = true
            backwardButton.isHidden = true
            questionStackView.isHidden = false
            
        default:
            break
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
        animation.duration = RegistrationSizes.InputPasswordLabel.shakeDuration
        animation.repeatCount = RegistrationSizes.InputPasswordLabel.shareRepeatings
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
    
    private func changeInputPasswordLabelDependsOnState() {
        switch viewState {
        case .firstLaunch:
            inputPasswordLabel.text = Text.Common.createPassword
            inputPasswordLabel.textColor = Asset.textColor.color

        case .repeatPassword:
            inputPasswordLabel.text = Text.Common.repeatPassword
            inputPasswordLabel.textColor = Asset.textColor.color
        
        case .passwordsNotEqual:
            inputPasswordLabel.text = Text.Common.passwordsNotEqual
            inputPasswordLabel.textColor = Asset.redFailure.color
        
        default:
            break
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
    
    @objc private func hideRepeatPasswordView() {
        viewState = .firstLaunch
        backwardButton.isHidden = true
        changeInputPasswordLabelDependsOnState()
        clearPasswordLabels()
        presenter.clearPasswords()
    }
    
    @objc private func textFieldHideKeyboard() {
        answerTextField.resignFirstResponder()
    }
    
    @objc private func saveDataTapped() {
        presenter.handleAnswer(answer: answerTextField.text)
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
    
    func passwordsDoesnotMatch() {
        viewState = .passwordsNotEqual
        changeInputPasswordLabelDependsOnState()
        clearPasswordLabels()
        shakeInputPasswordLabel()
    }
    
    func presentRestorePasswordQuestion() {
        proceedFilledPassword()
    }
    
    func presentAnswerError(description: String) {
        let popup = Popup(title: Text.Common.error, description: description)
        popup.addButton(title: Text.Common.confirm, type: .custom, action: nil)
        popup.alpha = 0
        showPopup(popup: popup)
    }
    
    func presentConfirmPopup(description: String) {
        let popup = Popup(title: Text.Common.confirmation, description: description)
        popup.addButton(title: Text.Common.cancel, type: .custom, action: nil)
        popup.addButton(title: Text.Common.confirm, type: .custom) { [weak self] in
            self?.presenter.saveRegistrationData(question: Text.Questions.whereWereYouBorn)
        }
        popup.alpha = 0
        showPopup(popup: popup)
    }
    
    func completeRegistration(isDataSeaved: Bool) {
        if isDataSeaved {
            let navigationController = UINavigationController(rootViewController: LoginConfigurator().setupModule())
            WindowService.setLoginViewController(vc: navigationController)
            WindowService.replaceRootViewController(with: navigationController)
        } else {
            let popup = Popup(title: Text.Common.error, description: Text.Descriptions.saveDataError)
            popup.alpha = 0
            showPopup(popup: popup)
        }
    }
}

extension RegistrationViewController: KeyboardDelegate {
    
    func handleKeyboardTap(key: KeyboardView.KeyType) {
        if viewState == .passwordsNotEqual {
            viewState = .repeatPassword
            changeInputPasswordLabelDependsOnState()
        }
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
        
        default:
            break
        }
    }
    
    private func deletePasswordNumberDependsOnViewState() {
        switch viewState {
        case .firstLaunch:
            presenter.deletePasswordLastNumber()

        case .repeatPassword:
            presenter.deleteRepeatPasswordLastNumber()
            
        default:
            break
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
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        label.text = text
        return label
    }
    
    private func makeBackwardButton() -> CustomButton {
        let button = CustomButton()
        button.setTitle(Text.Common.backward, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.setTitleColor(Asset.buttonsColor.color, for: .normal)
        button.addTarget(self, action: #selector(hideRepeatPasswordView), for: .touchUpInside)
        return button
    }
    
    private func makeAnswerTextField() -> UITextField {
        // TODO: Think about colors
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.backgroundColor = Asset.darkBlueAndWhiteHalfTransparent.color
        field.textAlignment = .left
        field.autocapitalizationType = .none
        field.layer.borderWidth = RegistrationSizes.AnswerTextField.boarderWidth
        field.layer.cornerRadius = RegistrationSizes.AnswerTextField.cornerRadius
        field.layer.borderColor = Asset.textColor.color.cgColor
        field.borderStyle = .roundedRect
        field.textColor = Asset.textColor.color
        field.tintColor = Asset.textColor.color
        field.autocorrectionType = .no
        field.keyboardType = .default
        field.returnKeyType = .search
        field.attributedPlaceholder = NSAttributedString(
            string: Text.Common.typeAnswerPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: Asset.textColorHalfTransparent.color
            ]
        )
        field.addTarget(self, action: #selector(saveDataTapped), for: .editingDidEndOnExit)
        return field
    }
    
    private func makeSaveRegistrationData() -> CustomButton {
        let button = CustomButton()
        button.setTitle(Text.Common.save, for: .normal)
        button.backgroundColor = Asset.darkBlueAndWhiteHalfTransparent.color
        button.layer.cornerRadius = RegistrationSizes.SaveAnswerButton.cornerRadius
        button.setTitleColor(Asset.textColor.color, for: .normal)
        button.addTarget(self, action: #selector(saveDataTapped), for: .touchUpInside)
        return button
    }
    
    private func makeQuestionStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        for view in views {
            stackView.addArrangedSubview(view)
        }
        stackView.axis = .vertical
        stackView.spacing = RegistrationSizes.QuestionStackView.spacing
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension RegistrationViewController {
    
    private func setConstraints() {
        setKeyboardConstraints()
        setPasswordStackConstraints()
        setInputPasswordLabelConstraints()
        setBackwardButtonConstraints()
        setAnswerStackViewConstraints()
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
    
    private func setQuestionLabelConstraints() {
        questionLabel.snp.makeConstraints { maker in
            maker.height.equalTo(25)
        }
    }
    
    private func setAnswerStackViewConstraints() {
        questionStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(RegistrationSizes.QuestionStackView.widthMultiplyer)
            maker.height.equalTo(RegistrationSizes.QuestionStackView.height)
        }
    }
    
    private func setPopupConstraints(view: UIView) {
        view.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
