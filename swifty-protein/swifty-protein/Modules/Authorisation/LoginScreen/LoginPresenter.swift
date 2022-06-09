//
//  LoginPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

protocol LoginPresenterProtocol {
    func handleNewPasswordNumber(number: Int)
    func deleteLastNumber()
    func tryLogin()
    func clearPassword()
}

final class LoginPresenter: LoginPresenterProtocol {
    
    private var password = ""
    
    private weak var viewController: LoginViewControllerProtocol!
    
    init(viewController: LoginViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func handleNewPasswordNumber(number: Int) {
        if password.count < LoginSizes.passwordLength {
            password.append(String(number))
            viewController.changePasswordLabelState(index: password.count - 1, isFilled: true)
            print(password)
        }
    }
    
    func deleteLastNumber() {
        if !password.isEmpty {
            password.removeLast()
            viewController.changePasswordLabelState(index: password.count, isFilled: false)
        }
    }
    
    func tryLogin() {
        guard let savedPassword = KeychainService.getString(key: .password)
        else {
            clearPassword()
            viewController.showFailedToLoginPopup(description: Text.Descriptions.unexpectedError)
            return
        }
        if savedPassword == password {
            clearPassword()
            viewController.presentProteinListScreen()
        } else {
            clearPassword()
            viewController.showFailedToLoginPopup(description: Text.Descriptions.wrongPassword)
        }
    }
    
    func clearPassword() {
        password = ""
    }
}
