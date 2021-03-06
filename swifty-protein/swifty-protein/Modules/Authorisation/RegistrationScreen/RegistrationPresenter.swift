//
//  RegistrationPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/6/22.
//

import UIKit

protocol RegistrationPresenterProtocol {
    func handleNewPasswordNumber(number: Int)
    func handleNewRepeatedPasswordNumber(number: Int)
    func deletePasswordLastNumber()
    func deleteRepeatPasswordLastNumber()
    func clearPasswords()
    func handleAnswer(answer: String?)
    func saveRegistrationData(question: String)
}

final class RegistrationPresenter: RegistrationPresenterProtocol {
    
    private var password = ""
    private var repeatPassword = ""
    private var answer = ""
    
    private weak var viewController: RegistrationViewControllerProtocol!
    
    init(viewController: RegistrationViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func handleNewPasswordNumber(number: Int) {
        if password.count < RegistrationSizes.passwordLength {
            viewController.changePasswordLabelState(index: password.count, isFilled: true)
            password.append(String(number))
            print(password)
        }
        if password.count == RegistrationSizes.passwordLength {
            viewController.presentRepeatPasswordView()
        }
    }
    
    func handleNewRepeatedPasswordNumber(number: Int) {
        if repeatPassword.count < RegistrationSizes.passwordLength {
            viewController.changePasswordLabelState(index: repeatPassword.count, isFilled: true)
            repeatPassword.append(String(number))
            print(repeatPassword)
        }
        if repeatPassword.count == RegistrationSizes.passwordLength {
            if password == repeatPassword {
                viewController.presentRestorePasswordQuestion()
            } else {
                repeatPassword.removeAll()
                viewController.passwordsDoesnotMatch()
            }
        }
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
    
    func handleAnswer(answer: String?) {
        guard let text = answer,
              !text.isEmpty
        else {
            viewController.presentAnswerError(description: Text.Descriptions.emptyAnswer)
            return
        }
        guard text.count < 30
        else {
            viewController.presentAnswerError(description: Text.Descriptions.longAnswer)
            return
        }
        self.answer = text
        viewController.presentConfirmPopup(description: Text.Descriptions.confirmAnswer) 
    }
    
    func saveRegistrationData(question: String) {
        let restorePasswordData = RecreatePasswordData(question: question, answer: answer)
        guard KeychainService.set(data: password, key: .password),
              let data = try? JSONEncoder().encode(restorePasswordData),
              KeychainService.set(data: data, key: .recreatePasswordAnswer)
        else {
            viewController.completeRegistration(isDataSeaved: false)
            return
        }
        FirstLaunchChecker.isFirstLaunch = false
        viewController.completeRegistration(isDataSeaved: true)
    }
}
