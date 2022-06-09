//
//  RestorePasswordPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

protocol RestorePasswordPresenterProtocol {
    func handleNewPasswordNumber(number: Int)
    func handleNewRepeatedPasswordNumber(number: Int)
    func handleAnswer(answer: String?)
    func deletePasswordLastNumber()
    func deleteRepeatPasswordLastNumber()
    func clearPasswords()
}

final class RestorePasswordPresenter: RestorePasswordPresenterProtocol {
    
    private var password = ""
    private var repeatPassword = ""
    
    private weak var viewController: RestorePasswordViewControllerProtocol!
    
    init(viewController: RestorePasswordViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func handleNewPasswordNumber(number: Int) {
        if password.count < RestorePasswordSizes.passwordLength {
            viewController.changePasswordLabelState(index: password.count, isFilled: true)
            password.append(String(number))
            print(password)
        }
        if password.count == RestorePasswordSizes.passwordLength {
            viewController.presentRepeatPasswordView()
        }
    }
    
    func handleNewRepeatedPasswordNumber(number: Int) {
        if repeatPassword.count < RestorePasswordSizes.passwordLength {
            viewController.changePasswordLabelState(index: repeatPassword.count, isFilled: true)
            repeatPassword.append(String(number))
        }
        if repeatPassword.count == RestorePasswordSizes.passwordLength {
            if password == repeatPassword {
                saveNewPassword()
            } else {
                repeatPassword.removeAll()
                viewController.passwordsDoesNotMatch()
            }
        }
    }
    
    func handleAnswer(answer: String?) {
        guard let text = answer,
              !text.isEmpty
        else {
            viewController.presentAnswerError(description: Text.Descriptions.emptyAnswer)
            return
        }
        guard let userAnswerData = KeychainService.getData(key: .recreatePasswordAnswer),
              let userAnswer = decodeMessage(data: userAnswerData, type: RecreatePasswordData.self)
        else {
            viewController.presentAnswerError(description: Text.Descriptions.unexpectedError)
            return
        }
        guard userAnswer.answer == text
        else {
            viewController.presentAnswerError(description: Text.Descriptions.wrongAnswer)
            return
        }
        viewController.showPasswordViewState()
    }
    
    func deletePasswordLastNumber() {
        if !password.isEmpty {
            password.removeLast()
            viewController.changePasswordLabelState(index: password.count, isFilled: false)
        }
    }
    
    func deleteRepeatPasswordLastNumber() {
        if !repeatPassword.isEmpty {
            repeatPassword.removeLast()
            viewController.changePasswordLabelState(index: repeatPassword.count, isFilled: false)
        }
    }
    
    func clearPasswords() {
        password.removeAll()
        repeatPassword.removeAll()
    }
    
    private func saveNewPassword() {
        guard KeychainService.delete(key: .password) &&
              KeychainService.set(data: password, key: .password)
        else {
            viewController.presentAnswerError(description: Text.Descriptions.unexpectedError)
            return
        }
        viewController.presentSuccessPopup()
    }
}
