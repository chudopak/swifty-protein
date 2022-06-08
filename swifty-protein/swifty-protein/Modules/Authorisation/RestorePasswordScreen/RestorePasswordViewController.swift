//
//  RestorePasswordViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

protocol RestorePasswordViewControllerProtocol: AnyObject {
    func changePasswordLabelState(index: Int, isFilled: Bool)
    func presentAnswerError(description: String)
    func presentRepeatPasswordView()
    func showPasswordViewState()
    func presentSuccessPopup()
    func passwordsDoesNotMatch()
}

final class RestorePasswordViewController: UIViewController, UITextFieldDelegate {
    
    private enum ViewState {
        case question, password, repeatPassword, passwordsNotEqual
    }
    
    private var viewState: ViewState = .question
    
    private var presenter: RestorePasswordPresenterProtocol!
    
    private var passwordLabels = [UIView]()
    
    private lazy var keyboard = makeKeyboardView()
    private lazy var passwordStackView = makeStackView(views: passwordLabels)
    private lazy var inputPasswordLabel = makeLabel(text: Text.Common.createPassword)
    private lazy var backwardButton = makeBackwardButton()
    
    private lazy var answerTextField = makeAnswerTextField()
    private lazy var saveRegistrationDataButton = makeCompareAnswerData()
    private lazy var questionLabel = makeLabel(text: Text.Questions.whereWereYouBorn)
    private lazy var questionStackView = makeQuestionStackView(
        views: [
            questionLabel,
            answerTextField,
            saveRegistrationDataButton
        ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        setGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    func setupComponents(presenter: RestorePasswordPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setView() {
        view.backgroundColor = Asset.primaryBackground.color
        view.addSubview(questionStackView)
        view.addSubview(keyboard)
        keyboard.isHidden = true
        passwordLabels.reserveCapacity(RestorePasswordSizes.passwordLength)
        for _ in 0..<RestorePasswordSizes.passwordLength {
            let label = makePasswordLabel()
            passwordLabels.append(label)
            setPasswordNumberLabelConstraints(label: label)
        }
        view.addSubview(passwordStackView)
        passwordStackView.isHidden = true
        view.addSubview(inputPasswordLabel)
        inputPasswordLabel.isHidden = true
        view.addSubview(backwardButton)
        backwardButton.isHidden = true
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        navigationController?.navigationBar.isHidden = false
        let imageView = UIImageView(image: Asset.moleculePurpleOrange.image)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: NavigationBarTitleView.width,
                height: NavigationBarTitleView.height
            )
        )
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(textFieldHideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
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
    
    private func shakeInputPasswordLabel() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = RestorePasswordSizes.InputPasswordLabel.shakeDuration
        animation.repeatCount = RestorePasswordSizes.InputPasswordLabel.shareRepeatings
        animation.autoreverses = true
        animation.fromValue = NSValue(
            cgPoint: CGPoint(
                x: inputPasswordLabel.center.x - RestorePasswordSizes.InputPasswordLabel.shakeOffset,
                y: inputPasswordLabel.center.y
            )
        )
        animation.toValue = NSValue(
            cgPoint: CGPoint(
                x: inputPasswordLabel.center.x + RestorePasswordSizes.InputPasswordLabel.shakeOffset,
                y: inputPasswordLabel.center.y
            )
        )
        inputPasswordLabel.layer.add(animation, forKey: "position")
    }
    
    private func changeInputPasswordLabelDependsOnState() {
        switch viewState {
        case .password:
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
    
    private func clearPasswordLabels() {
        for view in passwordLabels {
            view.backgroundColor = .clear
        }
        view.layoutIfNeeded()
    }
    
    @objc private func compareToSavedAnswer() {
        presenter.handleAnswer(answer: answerTextField.text)
    }
    
    @objc private func textFieldHideKeyboard() {
        answerTextField.resignFirstResponder()
    }
    
    @objc private func hideRepeatPasswordView() {
        viewState = .password
        backwardButton.isHidden = true
        changeInputPasswordLabelDependsOnState()
        clearPasswordLabels()
        presenter.clearPasswords()
    }
}

extension RestorePasswordViewController: RestorePasswordViewControllerProtocol {

    func changePasswordLabelState(index: Int, isFilled: Bool) {
        if index >= 0 && index < passwordLabels.count {
            passwordLabels[index].backgroundColor = isFilled
                                                        ? Asset.textColor.color
                                                        : .clear
            passwordLabels[index].layoutIfNeeded()
        }
    }
    
    func presentAnswerError(description: String) {
        let popup = Popup(title: Text.Common.error, description: description)
        popup.addButton(title: Text.Common.confirm, type: .custom, action: nil)
        popup.alpha = 0
        showPopup(popup: popup)
    }
    
    func showPasswordViewState() {
        viewState = .password
        questionStackView.isHidden = true
        passwordStackView.isHidden = false
        inputPasswordLabel.isHidden = false
        keyboard.isHidden = false
    }
    
    func presentRepeatPasswordView() {
        viewState = .repeatPassword
        changeInputPasswordLabelDependsOnState()
        backwardButton.isHidden = false
        clearPasswordLabels()
    }
    
    func passwordsDoesNotMatch() {
        viewState = .passwordsNotEqual
        changeInputPasswordLabelDependsOnState()
        clearPasswordLabels()
        shakeInputPasswordLabel()
    }
    
    func presentSuccessPopup() {
        let popup = Popup(title: Text.Common.success, description: Text.Descriptions.passwordChangd)
        popup.addButton(title: Text.Common.confirm, type: .custom) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        popup.alpha = 0
        showPopup(popup: popup)
    }
}

extension RestorePasswordViewController: KeyboardDelegate {
    
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
        case .password:
            presenter.handleNewPasswordNumber(number: number)

        case .repeatPassword:
            presenter.handleNewRepeatedPasswordNumber(number: number)
        
        default:
            break
        }
    }
    
    private func deletePasswordNumberDependsOnViewState() {
        switch viewState {
        case .password:
            presenter.deletePasswordLastNumber()

        case .repeatPassword:
            presenter.deleteRepeatPasswordLastNumber()
            
        default:
            break
        }
    }
}

extension RestorePasswordViewController {
    
    private func makeKeyboardView() -> KeyboardView {
        let view = KeyboardView(delegate: self)
        return view
    }
    
    private func makePasswordLabel() -> UILabel {
        let field = UILabel()
        field.clipsToBounds = true
        field.layer.borderWidth = RestorePasswordSizes.PasswordDotLabel.boarderWidth
        field.layer.borderColor = Asset.textColor.color.cgColor
        field.layer.cornerRadius = RestorePasswordSizes.PasswordDotLabel.cornerRadius
        return field
    }
    
    private func makeStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        for item in views {
            stackView.addArrangedSubview(item)
        }
        stackView.axis = .horizontal
        stackView.spacing = RestorePasswordSizes.PasswordStack.spacing
        return stackView
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        label.text = text
        return label
    }
    
    private func makeAnswerTextField() -> UITextField {
        // TODO: Think about colors
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.backgroundColor = Asset.darkBlueAndWhiteHalfTransparent.color
        field.textAlignment = .left
        field.autocapitalizationType = .none
        field.layer.borderWidth = RestorePasswordSizes.AnswerTextField.boarderWidth
        field.layer.cornerRadius = RestorePasswordSizes.AnswerTextField.cornerRadius
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
        field.addTarget(self, action: #selector(compareToSavedAnswer), for: .editingDidEndOnExit)
        return field
    }
    
    private func makeCompareAnswerData() -> CustomButton {
        let button = CustomButton()
        button.setTitle(Text.Common.compare, for: .normal)
        button.backgroundColor = Asset.darkBlueAndWhiteHalfTransparent.color
        button.layer.cornerRadius = RestorePasswordSizes.SaveAnswerButton.cornerRadius
        button.setTitleColor(Asset.textColor.color, for: .normal)
        button.addTarget(self, action: #selector(compareToSavedAnswer), for: .touchUpInside)
        return button
    }
    
    private func makeQuestionStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        for view in views {
            stackView.addArrangedSubview(view)
        }
        stackView.axis = .vertical
        stackView.spacing = RestorePasswordSizes.QuestionStackView.spacing
        stackView.distribution = .fillEqually
        return stackView
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
}

extension RestorePasswordViewController {
    
    private func setConstraints() {
        setQuestionStackViewConstraints()
        setPasswordStackConstraints()
        setKeyboardConstraints()
        setInputPasswordLabelConstraints()
        setBackwardButtonConstraints()
    }
    
    private func setPasswordNumberLabelConstraints(label: UILabel) {
        label.snp.makeConstraints { maker in
            maker.width.equalTo(RestorePasswordSizes.PasswordDotLabel.width)
            maker.height.equalTo(RestorePasswordSizes.PasswordDotLabel.height)
        }
    }
    
    private func setPasswordStackConstraints() {
        passwordStackView.snp.makeConstraints { maker in
            maker.width.equalTo(RestorePasswordSizes.PasswordStack.width)
            maker.height.equalTo(RestorePasswordSizes.PasswordStack.height)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(keyboard.snp.top).offset(-RestorePasswordSizes.PasswordStack.bottom)
        }
    }
    
    private func setKeyboardConstraints() {
        keyboard.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(RestorePasswordSizes.KeyboardView.centerYOffset)
            maker.width.equalTo(RestorePasswordSizes.KeyboardView.width)
            maker.height.equalTo(RestorePasswordSizes.KeyboardView.height)
        }
    }
    
    private func setQuestionStackViewConstraints() {
        questionStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(RestorePasswordSizes.QuestionStackView.widthMultiplyer)
            maker.height.equalTo(RestorePasswordSizes.QuestionStackView.height)
        }
    }
    
    private func setInputPasswordLabelConstraints() {
        inputPasswordLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.height.equalTo(RestorePasswordSizes.InputPasswordLabel.height)
            maker.bottom.equalTo(passwordStackView.snp.top).offset(-RestorePasswordSizes.InputPasswordLabel.bottomOffset)
        }
    }
    
    private func setBackwardButtonConstraints() {
        backwardButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(RestorePasswordSizes.SavePasswordButton.width)
            maker.height.equalTo(RestorePasswordSizes.SavePasswordButton.height)
            maker.top.equalTo(keyboard.snp.bottom).offset(RestorePasswordSizes.SavePasswordButton.topOffset)
        }
    }
    
    private func setPopupConstraints(view: UIView) {
        view.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
